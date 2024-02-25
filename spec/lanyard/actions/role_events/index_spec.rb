# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/index_contracts'

RSpec.describe Lanyard::Actions::RoleEvents::Index do
  include Cuprum::Rails::RSpec::Contracts::Actions::IndexContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      default_order: :slug,
      entity_class:  RoleEvent
    )
  end
  let(:cycle) { FactoryBot.build(:cycle) }
  let(:role)  { FactoryBot.build(:role, cycle: cycle) }
  let(:events) do
    Array
      .new(3) do |index|
        FactoryBot.build(:event, role: role, event_index: index)
      end
      .sort_by(&:name)
  end
  let(:params) { { 'role_id' => role.id } }

  before(:example) do
    cycle.save!

    role.save!

    events.each(&:save!)

    3.times { FactoryBot.create(:event, :with_role) }
  end

  include_contract 'should be an index action',
    existing_entities: -> { events },
    params:            -> { params } \
  do
    context 'with role_id: nil' do
      let(:params) do
        super().tap { |hsh| hsh.delete('role_id') }
      end
      let(:expected_error) do
        Cuprum::Rails::Errors::MissingParameter.new(
          parameter_name: 'role_id',
          parameters:     params
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'with role_id: an invalid id' do
      let(:role_id) { SecureRandom.uuid }
      let(:params)  { super().merge('role_id' => role_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: role_id,
          collection_name: 'roles',
          primary_key:     true
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'with role_id: an invalid slug' do
      let(:role_id) { 'example-slug' }
      let(:params)  { super().merge('role_id' => role_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: role_id,
          collection_name: 'roles'
        )
      end

      it 'should return a failing result' do
        expect(call_action)
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    context 'with role_id: an valid slug' do
      let(:params) { super().merge('role_id' => role.id) }

      include_contract 'should find the entities',
        existing_entities: -> { events },
        params:            -> { params }
    end
  end
end
