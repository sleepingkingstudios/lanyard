# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/create_contracts'

RSpec.describe Lanyard::Actions::RoleEvents::Create, type: :action do
  include Cuprum::Rails::RSpec::Actions::CreateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         RoleEvent,
      permitted_attributes: %i[
        event_date
        role_id
        slug
        type
      ]
    )
  end
  let(:role) { FactoryBot.create(:role, :with_cycle) }
  let(:invalid_attributes) do
    { 'role_id' => role.id, 'event_date' => nil }
  end
  let(:valid_attributes) do
    { 'role_id' => role.id, 'event_date' => '1982-07-09' }
  end
  let(:expected_attributes) do
    {
      'event_date'  => Date.new(1982, 7, 9),
      'event_index' => 0,
      'slug'        => '1982-07-09-0-event'
    }
  end

  include_contract 'create action contract',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: lambda { |hsh|
      hsh.merge({ 'event_index' => 0, 'slug' => '0-event' })
    },
    expected_attributes_on_success: ->(hsh) { hsh.merge(expected_attributes) } \
  do
    describe 'with type: an invalid status event type' do
      let(:role) do
        FactoryBot.create(:role, :interviewing, :with_cycle)
      end
      let(:type)             { RoleEvents::AppliedEvent.name }
      let(:expected_status)  { RoleEvents::AppliedEvent.new.status }
      let(:valid_statuses)   { RoleEvents::AppliedEvent.new.valid_statuses }
      let(:valid_attributes) { super().merge('type' => type) }
      let(:expected_error) do
        be_a(Lanyard::Errors::Roles::InvalidStatusTransition).and(
          have_attributes(
            current_status: role.status,
            status:         expected_status,
            valid_statuses: valid_statuses
          )
        )
      end
      let(:expected_attributes) do
        valid_attributes.merge({
          'event_date'  => Date.new(1982, 7, 9),
          'event_index' => 0,
          'slug'        => '1982-07-09-0-applied'
        })
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should return the invalid role event', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        value = call_action.value

        expect(value).to deep_match({
          'event' => be_a(RoleEvents::AppliedEvent),
          'role'  => role
        })
        expect(value['event']).to have_attributes(expected_attributes)
      end

      it 'should not create the event' do
        expect { call_action }.not_to change(RoleEvent, :count)
      end

      it 'should not update the role' do
        expect { call_action }.not_to(change { role.reload.attributes })
      end
    end

    describe 'with type: a valid status event type' do
      let(:type)             { RoleEvents::AppliedEvent.name }
      let(:expected_status)  { RoleEvents::AppliedEvent.new.status }
      let(:valid_attributes) { super().merge('type' => type) }

      include_contract 'should create the entity',
        valid_attributes: -> { valid_attributes } \
      do
        it 'should update the role' do
          expect { call_action }
            .to(
              change { role.reload.status }
              .to be == expected_status
            )
        end
      end
    end
  end
end
