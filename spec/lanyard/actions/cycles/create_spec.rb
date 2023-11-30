# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/create_contracts'

RSpec.describe Lanyard::Actions::Cycles::Create, type: :action do
  include Cuprum::Rails::RSpec::Actions::CreateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         Cycle,
      permitted_attributes: %i[
        active
        name
        season_index
        slug
        ui_eligible
        year
      ]
    )
  end
  let(:invalid_attributes) do
    { 'season_index' => '' }
  end
  let(:valid_attributes) do
    {
      'season_index' => Cycle::Seasons::WINTER,
      'year'         => '1996'
    }
  end
  let(:expected_attributes) do
    {
      'name'        => 'Winter 1996',
      'slug'        => 'winter-1996',
      'active'      => false,
      'ui_eligible' => false
    }
  end

  include_contract 'create action contract',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: ->(hsh) { hsh.merge({ 'slug' => '' }) },
    expected_attributes_on_success: ->(hsh) { hsh.merge(expected_attributes) } \
  do
    describe 'with name: an empty String' do
      let(:valid_attributes) { super().merge({ 'name' => '' }) }

      include_contract 'should create the entity',
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with name: a valid String' do
      let(:valid_attributes) { super().merge({ 'name' => 'Custom Name' }) }
      let(:expected_attributes) do
        super().merge({ 'name' => 'Custom Name', 'slug' => 'custom-name' })
      end

      include_contract 'should create the entity',
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes) { super().merge({ 'slug' => '' }) }

      include_contract 'should create the entity',
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should create the entity',
        valid_attributes: -> { valid_attributes }
    end
  end
end
