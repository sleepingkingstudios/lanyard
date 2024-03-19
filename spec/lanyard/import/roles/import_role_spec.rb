# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'

RSpec.describe Lanyard::Import::Roles::ImportRole do
  subject(:command) { described_class.new(repository: repository, **options) }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:options)    { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository, :year)
    end
  end

  describe '#call' do
    shared_context 'when an active cycle is defined' do
      let(:cycle) { FactoryBot.build(:cycle, :active) }

      before(:example) { cycle.save! }
    end

    let(:attributes) do
      {
        'company_name' => 'Indigo League',
        'job_title'    => 'Monster Trainer'
      }
    end
    let(:current_time) { Time.current }
    let(:expected_attributes) do
      slug = "#{Time.current.to_date.iso8601}-indigo-league-monster-trainer"

      attributes.merge(
        'cycle_id' => cycle.id,
        'status'   => Role::Statuses::NEW,
        'slug'     => slug
      )
    end

    before(:example) do
      allow(Time).to receive_messages(
        current: current_time,
        now:     current_time
      )
    end

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    describe 'when an active cycle is not defined' do
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attributes:      { 'active' => true },
          collection_name: 'cycles'
        )
      end

      it 'should return a failing result' do
        expect(command.call(attributes: attributes))
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create a role' do
        expect { command.call(attributes: attributes) }
          .not_to change(Role, :count)
      end

      it 'should not create any role events' do
        expect { command.call(attributes: attributes) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with invalid attributes' do
      include_context 'when an active cycle is defined'

      let(:attributes) { super().merge(status: 'indeterminate') }
      let(:expected_error) do
        errors = Stannum::Errors.new

        errors[:status].add(
          'inclusion',
          message:   'is not included in the list',
          allow_nil: true,
          value:     'indeterminate'
        )

        Cuprum::Collections::Errors::FailedValidation.new(
          errors:       errors,
          entity_class: Role
        )
      end

      it 'should return a failing result' do
        expect(command.call(attributes: attributes))
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create a role' do
        expect { command.call(attributes: attributes) }
          .not_to change(Role, :count)
      end

      it 'should not create any role events' do
        expect { command.call(attributes: attributes) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with minimal attributes' do
      include_context 'when an active cycle is defined'

      it 'should return a passing result', :aggregate_failures do
        result = command.call(attributes: attributes)

        expect(result).to be_a_passing_result
        expect(result.value).to be_a Role
        expect(result.value).to have_attributes(expected_attributes)
      end

      it 'should create the role', :aggregate_failures do
        expect { command.call(attributes: attributes) }
          .to change(Role, :count)
          .by(1)

        expect(Role.last).to have_attributes(expected_attributes)
      end

      it 'should not create any role events' do
        expect { command.call(attributes: attributes) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with parsed attributes' do
      include_context 'when an active cycle is defined'

      let(:attributes) do
        notes = [
          'full_time',
          'in_person',
          'See www.example.com'
        ]

        super().merge(
          'compensation' => '$1,000,000/yr',
          'source'       => 'Email - giovanni@example.com',
          'notes'        => notes
        )
      end
      let(:expected_attributes) do
        super().merge(
          'compensation'      => '$1,000,000/yr',
          'compensation_type' => Role::CompensationTypes::SALARIED,
          'contract_type'     => Role::ContractTypes::FULL_TIME,
          'location_type'     => Role::LocationTypes::IN_PERSON,
          'notes'             => 'See www.example.com',
          'source'            => Role::Sources::EMAIL,
          'source_details'    => 'giovanni@example.com'
        )
      end

      it 'should return a passing result', :aggregate_failures do
        result = command.call(attributes: attributes)

        expect(result).to be_a_passing_result
        expect(result.value).to be_a Role
        expect(result.value).to have_attributes(expected_attributes)
      end

      it 'should create the role', :aggregate_failures do
        expect { command.call(attributes: attributes) }
          .to change(Role, :count)
          .by(1)

        expect(Role.last).to have_attributes(expected_attributes)
      end

      it 'should not create any role events' do
        expect { command.call(attributes: attributes) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with attributes with events' do
      include_context 'when an active cycle is defined'

      let(:current_time) { Date.new(1996, 7, 1).beginning_of_day + 12.hours }
      let(:attributes) do
        events = [
          'Applied May 7',
          'Interview May 14',
          'Offered May 21'
        ]

        super().merge('events' => events)
      end
      let(:expected_attributes) do
        slug = "#{Time.current.year}-05-07-indigo-league-monster-trainer"

        super().except('events').merge(
          'last_event_at' => Date.new(1996, 6, 4).beginning_of_day,
          'slug'          => slug,
          'status'        => Role::Statuses::CLOSED
        )
      end

      it 'should return a passing result', :aggregate_failures do
        result = command.call(attributes: attributes)

        expect(result).to be_a_passing_result
        expect(result.value).to be_a Role
        expect(result.value).to have_attributes(expected_attributes)
      end

      it 'should create the role', :aggregate_failures do
        expect { command.call(attributes: attributes) }
          .to change(Role, :count)
          .by(1)

        expect(Role.last).to have_attributes(expected_attributes)
      end

      it 'should create each role event' do
        expect { command.call(attributes: attributes) }
          .to change(RoleEvent, :count).by(4)
      end

      it 'should create the applied event', :aggregate_failures do
        command.call(attributes: attributes)

        event = Role.last.events.where(event_index: 0).first
        expect(event).to be_a RoleEvents::AppliedEvent
        expect(event.event_date).to be == Date.new(1996, 5, 7)
      end

      it 'should create the interview event', :aggregate_failures do
        command.call(attributes: attributes)

        event = Role.last.events.where(event_index: 1).first
        expect(event).to be_a RoleEvents::InterviewEvent
        expect(event.event_date).to be == Date.new(1996, 5, 14)
      end

      it 'should create the offered event', :aggregate_failures do
        command.call(attributes: attributes)

        event = Role.last.events.where(event_index: 2).first
        expect(event).to be_a RoleEvents::OfferedEvent
        expect(event.event_date).to be == Date.new(1996, 5, 21)
      end

      it 'should create the expired event', :aggregate_failures do
        command.call(attributes: attributes)

        event = Role.last.events.where(event_index: 3).first
        expect(event).to be_a RoleEvents::ExpiredEvent
        expect(event.event_date).to be == Date.new(1996, 6, 4)
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end

  describe '#year' do
    let(:current_time) { Time.current }

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

    include_examples 'should define reader', :year, -> { current_time.year }

    context 'when initialized with year: value' do
      let(:options) { super().merge(year: 1998) }

      it { expect(command.year).to be 1998 }
    end
  end
end
