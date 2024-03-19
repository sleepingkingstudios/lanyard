# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::ImportRoles do
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
    let(:current_time) { Date.new(1996, 7, 1).beginning_of_day + 12.hours }
    let(:cycle)        { FactoryBot.build(:cycle, :active) }

    before(:example) do
      allow(Time).to receive_messages(
        current: current_time,
        now:     current_time
      )

      cycle.save!
    end

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:raw_data)
    end

    describe 'with an invalid data stream' do
      let(:raw_data) do
        <<~YAML
          ---
          - foo: bar: baz
        YAML
      end
      let(:error_message) do
        YAML.parse(raw_data)
      rescue Psych::SyntaxError => exception
        exception.message
      end
      let(:expected_error) do
        Lanyard::Import::Errors::ParseError.new(
          message:   error_message,
          raw_value: raw_data
        )
      end

      it 'should return a failing result' do
        expect(command.call(raw_data: raw_data))
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create any roles' do
        expect { command.call(raw_data: raw_data) }
          .not_to change(Role, :count)
      end

      it 'should not create any role events' do
        expect { command.call(raw_data: raw_data) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with an empty data stream' do
      let(:raw_data) do
        <<~YAML
          ---
        YAML
      end

      it 'should return a passing result' do
        expect(command.call(raw_data: raw_data))
          .to be_a_passing_result
          .with_value([])
      end

      it 'should not create any roles' do
        expect { command.call(raw_data: raw_data) }
          .not_to change(Role, :count)
      end

      it 'should not create any role events' do
        expect { command.call(raw_data: raw_data) }
          .not_to change(RoleEvent, :count)
      end
    end

    describe 'with a valid data stream' do
      let(:raw_data) do
        <<~YAML
          ---
          - company_name: Indigo League
            job_title: Monster Trainer
          - company_name: Pewter City Civic Society
            job_title: Gym Leader
            events:
            - Applied May 7
            - Interview May 14
            - Offered May 21
          - company_name: Team Rocket
            job_title: Executive
            compensation: $1,000,000/yr
            source: Email - giovanni@example.com
            notes:
            - in_person
            - full_time
            - See www.example.com
        YAML
      end
      let(:monster_trainer_role) do
        Role
          .where(
            company_name: 'Indigo League',
            job_title:    'Monster Trainer'
          )
          .first
      end
      let(:gym_leader_role) do
        Role
          .where(
            company_name: 'Pewter City Civic Society',
            job_title:    'Gym Leader'
          )
          .first
      end
      let(:rocket_executive_role) do
        Role
          .where(
            company_name: 'Team Rocket',
            job_title:    'Executive'
          )
          .first
      end
      let(:expected_value) do
        [
          monster_trainer_role,
          gym_leader_role,
          rocket_executive_role
        ]
      end

      it 'should return a passing result', :aggregate_failures do
        result = command.call(raw_data: raw_data)

        expect(result).to be_a_passing_result
        expect(result.value).to be == expected_value
      end

      it 'should create the basic role', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        command.call(raw_data: raw_data)

        expect(monster_trainer_role).to have_attributes(
          company_name:  'Indigo League',
          job_title:     'Monster Trainer',
          last_event_at: current_time,
          status:        Role::Statuses::NEW
        )
        expect(monster_trainer_role.events).to be == []
      end

      it 'should create the role with events', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        command.call(raw_data: raw_data)

        expect(gym_leader_role).to have_attributes(
          company_name:  'Pewter City Civic Society',
          job_title:     'Gym Leader',
          last_event_at: Date.new(1996, 6, 4).beginning_of_day,
          status:        Role::Statuses::CLOSED
        )
        expect(gym_leader_role.events.size).to be 4
      end

      it 'should create the role with details', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        command.call(raw_data: raw_data)

        expect(rocket_executive_role).to have_attributes(
          company_name:      'Team Rocket',
          compensation:      '$1,000,000/yr',
          compensation_type: Role::CompensationTypes::SALARIED,
          contract_type:     Role::ContractTypes::FULL_TIME,
          job_title:         'Executive',
          last_event_at:     current_time,
          location_type:     Role::LocationTypes::IN_PERSON,
          source:            Role::Sources::EMAIL,
          source_details:    'giovanni@example.com',
          status:            Role::Statuses::NEW
        )
        expect(rocket_executive_role.events).to be == []
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
