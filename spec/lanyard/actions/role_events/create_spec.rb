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
      permitted_attributes: %i[
        role_id
        slug
        type
      ],
      resource_class:       RoleEvent
    )
  end
  let(:role) { FactoryBot.create(:role, :with_cycle) }
  let(:invalid_attributes) do
    { 'role_id' => nil }
  end
  let(:valid_attributes) do
    { 'role_id' => role.id }
  end
  let(:current_time)        { Time.current }
  let(:timestamp)           { current_time.strftime('%Y-%m-%d') }
  let(:expected_slug)       { "#{timestamp}-event" }
  let(:expected_attributes) { { 'slug' => expected_slug } }

  before(:example) { allow(Time).to receive(:current).and_return(current_time) }

  include_contract 'create action contract',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: lambda { |hsh|
      hsh.merge({ 'slug' => expected_slug })
    },
    expected_attributes_on_success: ->(hsh) { hsh.merge(expected_attributes) } \
  do
    # rubocop:disable RSpec/MultipleMemoizedHelpers
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

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
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
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end