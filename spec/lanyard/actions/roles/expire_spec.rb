# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Actions::Roles::Expire do
  subject(:action) { described_class.new }

  let(:params)     { {} }
  let(:request)    { Cuprum::Rails::Request.new(params: params) }
  let(:repository) { Cuprum::Rails::Repository.new }

  describe '#call' do
    let(:current_time) { Time.current }

    def call_action
      action.call(request: request, repository: repository)
    end

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

    describe 'with a missing role id' do
      let(:params) { {} }
      let(:expected_error) do
        Cuprum::Rails::Errors::MissingParameter.new(
          parameters:     params,
          parameter_name: 'role_id'
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create an event' do
        expect { call_action }.not_to change(RoleEvent, :count)
      end
    end

    describe 'with an invalid role id' do
      let(:params) { super().merge('role_id' => SecureRandom.uuid) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: params['role_id'],
          collection_name: 'roles',
          primary_key:     true
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create an event' do
        expect { call_action }.not_to change(RoleEvent, :count)
      end
    end

    describe 'with a valid role id' do
      let(:role) do
        FactoryBot.create(
          :role,
          :with_cycle,
          updated_at:    1.month.ago,
          last_event_at: 1.month.ago
        )
      end
      let(:params) { super().merge('role_id' => role.id) }
      let!(:expected_date) do
        (role.last_event_at + 2.weeks).to_date
      end
      let(:expected_slug) do
        "#{expected_date}-0-expired"
      end
      let(:expected_attributes) do
        {
          'event_date'  => expected_date,
          'event_index' => 0,
          'role_id'     => role.id,
          'slug'        => expected_slug,
          'type'        => RoleEvents::ExpiredEvent.name
        }
      end
      let(:expected_value) do
        {
          'role'       => role,
          'role_event' => be_a(RoleEvents::ExpiredEvent).and(
            have_attributes(expected_attributes)
          )
        }
      end

      it 'should return a passing result', :aggregate_failures do
        result = call_action

        expect(result).to be_a_passing_result
        expect(result.value).to deep_match(expected_value)
      end

      it 'should create the role event', :aggregate_failures do
        expect { call_action }.to(change { role.reload.events.count }.by(1))

        expect(role.events.last).to have_attributes(expected_attributes)
      end

      it 'should update the role', :aggregate_failures do
        call_action

        role.reload
        expect(role.updated_at.to_i).to be == current_time.to_i
        expect(role.last_event_at).to be == expected_date
        expect(role.status).to be == Role::Statuses::CLOSED
      end
    end

    describe 'with an invalid role slug' do
      let(:params) { super().merge('role_id' => 'non-existent-role') }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: params['role_id'],
          collection_name: 'roles'
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not create an event' do
        expect { call_action }.not_to change(RoleEvent, :count)
      end
    end

    describe 'with a valid role slug' do
      let(:role) do
        FactoryBot.create(
          :role,
          :with_cycle,
          updated_at:    1.month.ago,
          last_event_at: 1.month.ago
        )
      end
      let(:params) { super().merge('role_id' => role.slug) }
      let!(:expected_date) do
        (role.last_event_at + 2.weeks).to_date
      end
      let(:expected_slug) do
        "#{expected_date}-0-expired"
      end
      let(:expected_attributes) do
        {
          'event_date'  => expected_date,
          'event_index' => 0,
          'role_id'     => role.id,
          'slug'        => expected_slug,
          'type'        => RoleEvents::ExpiredEvent.name
        }
      end
      let(:expected_value) do
        {
          'role'       => role,
          'role_event' => be_a(RoleEvents::ExpiredEvent).and(
            have_attributes(expected_attributes)
          )
        }
      end

      it 'should return a passing result', :aggregate_failures do
        result = call_action

        expect(result).to be_a_passing_result
        expect(result.value).to deep_match(expected_value)
      end

      it 'should create the role event', :aggregate_failures do
        expect { call_action }.to(change { role.reload.events.count }.by(1))

        expect(role.events.last).to have_attributes(expected_attributes)
      end

      it 'should update the role', :aggregate_failures do
        call_action

        role.reload
        expect(role.updated_at.to_i).to be == current_time.to_i
        expect(role.last_event_at).to be == expected_date
        expect(role.status).to be == Role::Statuses::CLOSED
      end
    end
  end
end
