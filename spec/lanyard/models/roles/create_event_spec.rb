# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::CreateEvent do
  subject(:command) { described_class.new(repository: repository) }

  let(:repository) { Cuprum::Rails::Repository.new }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to respond_to(:new)
        .with(0).arguments
        .and_keywords(:repository)
    end
  end

  describe '#call' do
    let(:current_time) { Time.current }
    let(:attributes)   { { 'event_date' => 1.day.ago.to_date } }
    let(:role) do
      FactoryBot.create(
        :role,
        :with_cycle,
        updated_at:    1.week.ago,
        last_event_at: 1.week.ago
      )
    end

    def call_command
      command.call(attributes: attributes, role: role)
    end

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

    describe 'with invalid attributes' do
      let(:attributes) { {} }
      let(:expected_error) do
        errors = Stannum::Errors.new

        errors[:event_date].add('blank', message: "can't be blank")

        Cuprum::Collections::Errors::FailedValidation.new(
          entity_class: RoleEvent,
          errors:       errors
        )
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create an event' do
        expect { call_command }.not_to change(RoleEvent, :count)
      end

      it 'should not update the role' do
        expect { call_command }.not_to(change { role.reload.attributes })
      end
    end

    describe 'with valid attributes' do
      let(:expected_slug) do
        "#{attributes['event_date'].iso8601}-0-event"
      end
      let(:expected_attributes) do
        {
          'event_date'  => attributes['event_date'],
          'event_index' => 0,
          'role_id'     => role.id,
          'slug'        => expected_slug
        }
      end
      let(:expected_value) do
        deep_match(
          {
            'role'       => role,
            'role_event' => be_a(RoleEvent).and(
              have_attributes(expected_attributes)
            )
          }
        )
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      it 'should create the role event', :aggregate_failures do
        expect { call_command }.to change { role.reload.events.count }.by(1)

        expect(role.events.last).to have_attributes(expected_attributes)
      end

      it 'should update the role', :aggregate_failures do
        call_command

        role.reload
        expect(role.updated_at.to_i).to be == current_time.to_i
        expect(role.last_event_at).to be == attributes['event_date']
      end

      context 'when the role has many events' do
        let(:expected_slug) do
          "#{attributes['event_date'].iso8601}-3-event"
        end
        let(:expected_attributes) do
          {
            'event_date'  => attributes['event_date'],
            'event_index' => 3,
            'role_id'     => role.id,
            'slug'        => expected_slug
          }
        end

        before(:example) do
          Array.new(3) do |index|
            FactoryBot.create(
              :event,
              role:        role,
              event_date:  2.weeks.ago,
              event_index: index
            )
          end
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end

        it 'should create the role event', :aggregate_failures do
          expect { call_command }.to(change { role.reload.events.count }.by(1))

          expect(role.events.order(:event_index).last)
            .to have_attributes(expected_attributes)
        end

        it 'should update the role', :aggregate_failures do
          call_command

          role.reload
          expect(role.updated_at.to_i).to be == current_time.to_i
          expect(role.last_event_at).to be == attributes['event_date']
        end
      end
    end

    describe 'with type: an invalid status event type' do
      let(:role) do
        FactoryBot.create(:role, :interviewing, :with_cycle)
      end
      let(:attributes) do
        super().merge('type' => RoleEvents::AppliedEvent.name)
      end
      let(:expected_error) do
        Lanyard::Errors::Roles::InvalidStatusTransition.new(
          current_status: role.status,
          status:         RoleEvents::AppliedEvent.new.status,
          valid_statuses: RoleEvents::AppliedEvent.new.valid_statuses
        )
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create an event' do
        expect { call_command }.not_to change(RoleEvent, :count)
      end

      it 'should not update the role' do
        expect { call_command }.not_to(change { role.reload.attributes })
      end
    end

    describe 'with type: a valid status event type' do
      let(:attributes) do
        super().merge('type' => RoleEvents::AppliedEvent.name)
      end
      let(:expected_slug) do
        "#{attributes['event_date'].iso8601}-0-applied"
      end
      let(:expected_attributes) do
        {
          'event_date'  => attributes['event_date'],
          'event_index' => 0,
          'role_id'     => role.id,
          'slug'        => expected_slug,
          'type'        => RoleEvents::AppliedEvent.name
        }
      end

      let(:expected_value) do
        deep_match(
          {
            'role'       => role,
            'role_event' => be_a(RoleEvents::AppliedEvent).and(
              have_attributes(expected_attributes)
            )
          }
        )
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      it 'should create the role event', :aggregate_failures do
        expect { call_command }.to(change { role.reload.events.count }.by(1))

        expect(role.events.last).to have_attributes(expected_attributes)
      end

      it 'should update the role', :aggregate_failures do
        call_command

        role.reload
        expect(role.updated_at.to_i).to be == current_time.to_i
        expect(role.last_event_at).to be == attributes['event_date']
        expect(role.status).to be == Role::Statuses::APPLIED
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
