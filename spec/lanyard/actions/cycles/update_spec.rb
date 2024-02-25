# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/update_contracts'

RSpec.describe Lanyard::Actions::Cycles::Update, type: :action do
  include Cuprum::Rails::RSpec::Contracts::Actions::UpdateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         Cycle,
      permitted_attributes: %i[
        name
        season_index
        slug
        year
      ]
    )
  end
  let(:invalid_attributes) do
    { 'year' => '' }
  end
  let(:valid_attributes) do
    { 'year' => '1996' }
  end
  let(:cycle) { FactoryBot.create(:cycle) }

  before(:example) { cycle.save }

  include_contract 'should be an update action',
    existing_entity:    -> { cycle },
    invalid_attributes: -> { invalid_attributes },
    valid_attributes:   -> { valid_attributes },
    primary_key_value:  -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) do
        { 'id' => cycle.slug, 'cycle' => valid_attributes }
      end

      include_contract 'should update the entity',
        existing_entity:  -> { cycle },
        valid_attributes: -> { valid_attributes },
        params:           -> { params }
    end

    describe 'with name: an empty String' do
      let(:valid_attributes) do
        super().merge({
          'name'         => '',
          'season_index' => Cycle::Seasons::WINTER
        })
      end
      let(:expected_attributes) { { 'name' => 'Winter 1996' } }

      include_contract 'should update the entity',
        existing_entity:     -> { cycle },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with name: a valid String' do
      let(:valid_attributes)    { super().merge({ 'name' => 'Custom Name' }) }
      let(:expected_attributes) { { 'name' => 'Custom Name' } }

      include_contract 'should update the entity',
        existing_entity:     -> { cycle },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes) do
        super().merge({
          'name' => 'Custom Name',
          'slug' => ''
        })
      end
      let(:expected_attributes) { { 'slug' => 'custom-name' } }

      include_contract 'should update the entity',
        existing_entity:     -> { cycle },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:  -> { cycle },
        valid_attributes: -> { valid_attributes }
    end
  end
end
