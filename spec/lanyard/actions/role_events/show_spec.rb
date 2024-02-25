# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/show_contracts'

RSpec.describe Lanyard::Actions::RoleEvents::Show do
  include Cuprum::Rails::RSpec::Contracts::Actions::ShowContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(entity_class: RoleEvent)
  end
  let(:cycle) { FactoryBot.build(:cycle) }
  let(:role)  { FactoryBot.build(:role, cycle: cycle) }
  let(:event) do
    FactoryBot.build(:event, role: role, event_date: Date.new(1982, 7, 9))
  end
  let(:params) do
    {
      'id'      => event.id,
      'role_id' => role.id
    }
  end

  before(:example) do
    cycle.save!

    role.save!

    event.save!
  end

  include_contract 'should be a show action contract',
    existing_entity:   -> { event },
    primary_key_value: -> { SecureRandom.uuid },
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

      include_contract 'should find the entity',
        existing_entity: -> { event },
        params:          -> { params }
    end

    describe 'with id: a slug' do
      let(:params) { super().merge('id' => event.slug) }

      include_contract 'should find the entity',
        existing_entity: -> { event },
        params:          -> { params }
    end
  end
end
