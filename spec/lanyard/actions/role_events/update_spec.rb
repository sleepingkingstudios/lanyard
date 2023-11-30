# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/update_contracts'

RSpec.describe Lanyard::Actions::RoleEvents::Update do
  include Cuprum::Rails::RSpec::Actions::UpdateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         RoleEvent,
      permitted_attributes: %i[
        event_date
        event_index
        role_id
        notes
        slug
        summary
        type
      ]
    )
  end
  let(:invalid_attributes) do
    { 'event_date' => Date.new(2010, 12, 17) }
  end
  let(:valid_attributes) do
    { 'summary' => 'Custom event', 'notes' => 'This job rocks!' }
  end
  let(:cycle) { FactoryBot.build(:cycle) }
  let(:role)  { FactoryBot.build(:role, cycle: cycle) }
  let(:event) do
    FactoryBot.build(:event, role: role, event_date: Date.new(1982, 7, 9))
  end
  let(:params) do
    {
      'id'         => event.id,
      'role_id'    => role.id,
      'role_event' => valid_attributes
    }
  end

  def format_data_attributes(hsh)
    summary = hsh.delete('summary')
    data    = hsh.fetch('data', {}).merge('summary' => summary)

    hsh.merge('data' => data)
  end

  before(:example) do
    cycle.save!

    role.save!

    event.save!
  end

  include_contract 'update action contract',
    existing_entity:     -> { event },
    invalid_attributes:  -> { invalid_attributes },
    valid_attributes:    -> { valid_attributes },
    expected_attributes: ->(hsh) { format_data_attributes(hsh) },
    primary_key_value:   -> { SecureRandom.uuid },
    params:              -> { params } \
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

      include_contract 'should update the entity',
        existing_entity:     -> { event },
        valid_attributes:    -> { valid_attributes },
        params:              -> { params },
        expected_attributes: ->(hsh) { format_data_attributes(hsh) }
    end

    describe 'with id: a slug' do
      let(:params) { super().merge('id' => event.slug) }

      include_contract 'should update the entity',
        existing_entity:     -> { event },
        valid_attributes:    -> { valid_attributes },
        params:              -> { params },
        expected_attributes: ->(hsh) { format_data_attributes(hsh) }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes) do
        super().merge({
          'event_date'  => event.event_date.iso8601,
          'event_index' => event.event_index,
          'slug'        => ''
        })
      end
      let(:expected_slug) { "#{event.event_date.iso8601}-0-event" }
      let(:expected_attributes) do
        {
          'event_date' => Date.parse(event.event_date.iso8601),
          'slug'       => expected_slug
        }
      end

      before(:example) do
        event.slug = 'custom-event'
        event.save!
      end

      include_contract 'should update the entity',
        existing_entity:     -> { event },
        valid_attributes:    -> { valid_attributes },
        params:              -> { params },
        expected_attributes: lambda { |hsh|
          format_data_attributes(hsh).merge(expected_attributes)
        }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:     -> { event },
        valid_attributes:    -> { valid_attributes },
        params:              -> { params },
        expected_attributes: ->(hsh) { format_data_attributes(hsh) }
    end
  end
end
