# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'

RSpec.describe Lanyard::Import::Roles::GenerateEvents do
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
    let(:current_time) { Date.new(1996, 6, 1).beginning_of_day + 12.hours }
    let(:role) do
      FactoryBot.create(
        :role,
        :with_cycle,
        updated_at:    1.day.ago,
        last_event_at: 1.week.ago
      )
    end

    def call_command
      command.call(events: events, role: role)
    end

    before(:example) do
      allow(Time).to receive_messages(
        current: current_time,
        now:     current_time
      )
    end

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:events, :role)
    end

    describe 'with events: an empty Array' do
      let(:events) { [] }

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(nil)
      end

      it 'should not create any role events' do
        expect { call_command }.not_to change(RoleEvent, :count)
      end

      it 'should not update the role' do
        expect { call_command }.not_to(change { role.reload.attributes })
      end
    end

    describe 'with events: an Array with invalid items' do
      let(:events) do
        [
          'Applied Jan 1',
          'Invalid Event',
          'Closed Mar 1'
        ]
      end
      let(:error_message) { 'wrong number of words' }
      let(:expected_error) do
        Lanyard::Import::Errors::ParseError.new(
          entity_class: RoleEvent,
          raw_value:    'Invalid Event',
          message:      error_message
        )
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create any role events' do
        expect { call_command }.not_to change(RoleEvent, :count)
      end

      it 'should not update the role' do
        expect { call_command }.not_to(change { role.reload.attributes })
      end
    end

    describe 'with events: an Array with valid items' do
      let(:events) do
        [
          'Applied May 7',
          'Interview May 14',
          'Offered May 21'
        ]
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(nil)
      end

      it 'should create each role event' do
        expect { call_command }.to change(RoleEvent, :count).by(3)
      end

      it 'should create the applied event', :aggregate_failures do
        call_command

        event = role.reload.events.where(event_index: 0).first
        expect(event).to be_a RoleEvents::AppliedEvent
        expect(event.event_date).to be == Date.new(1996, 5, 7)
      end

      it 'should create the interview event', :aggregate_failures do
        call_command

        event = role.reload.events.where(event_index: 1).first
        expect(event).to be_a RoleEvents::InterviewEvent
        expect(event.event_date).to be == Date.new(1996, 5, 14)
      end

      it 'should create the offered event', :aggregate_failures do
        call_command

        event = role.reload.events.where(event_index: 2).first
        expect(event).to be_a RoleEvents::OfferedEvent
        expect(event.event_date).to be == Date.new(1996, 5, 21)
      end

      it 'should update the role' do # rubocop:disable RSpec/ExampleLength
        call_command

        expect(role.reload).to have_attributes(
          status:        Role::Statuses::OFFERED,
          last_event_at: Date.new(1996, 5, 21),
          updated_at:    current_time
        )
      end

      context 'when initialized with year: value' do
        let(:options) { super().merge(year: 1998) }

        it 'should create the applied event', :aggregate_failures do
          call_command

          event = role.reload.events.where(event_index: 0).first
          expect(event).to be_a RoleEvents::AppliedEvent
          expect(event.event_date).to be == Date.new(1998, 5, 7)
        end

        it 'should create the interview event', :aggregate_failures do
          call_command

          event = role.reload.events.where(event_index: 1).first
          expect(event).to be_a RoleEvents::InterviewEvent
          expect(event.event_date).to be == Date.new(1998, 5, 14)
        end

        it 'should create the offered event', :aggregate_failures do
          call_command

          event = role.reload.events.where(event_index: 2).first
          expect(event).to be_a RoleEvents::OfferedEvent
          expect(event.event_date).to be == Date.new(1998, 5, 21)
        end
      end

      context 'when the role is expired' do
        let(:current_time) { Date.new(1996, 7, 1).beginning_of_day + 12.hours }

        it 'should create each role event' do
          expect { call_command }.to change(RoleEvent, :count).by(4)
        end

        it 'should create the expired event', :aggregate_failures do
          call_command

          event = role.reload.events.where(event_index: 3).first
          expect(event).to be_a RoleEvents::ExpiredEvent
          expect(event.event_date).to be == Date.new(1996, 6, 4)
        end

        it 'should update the role' do # rubocop:disable RSpec/ExampleLength
          call_command

          expect(role.reload).to have_attributes(
            status:        Role::Statuses::CLOSED,
            last_event_at: Date.new(1996, 6, 4).beginning_of_day,
            updated_at:    current_time
          )
        end
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
