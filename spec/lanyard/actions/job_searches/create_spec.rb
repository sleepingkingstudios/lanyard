# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/create_contracts'

RSpec.describe Lanyard::Actions::JobSearches::Create, type: :action do
  include Cuprum::Rails::RSpec::Actions::CreateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      permitted_attributes: %i[
        slug
        end_date
        start_date
      ],
      resource_class:       JobSearch
    )
  end
  let(:invalid_attributes) do
    { 'start_date' => '' }
  end
  let(:valid_attributes) do
    {
      'start_date' => '1982-07',
      'end_date'   => '1982-08'
    }
  end
  let(:expected_attributes) do
    {
      'start_date' => Date.new(1982, 7, 1),
      'end_date'   => Date.new(1982, 8, 31),
      'slug'       => '1982-07'
    }
  end

  include_contract 'create action contract',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: ->(hsh) { hsh.merge({ 'slug' => '' }) },
    expected_attributes_on_success: ->(hsh) { hsh.merge(expected_attributes) } \
  do
    describe 'with slug: an empty String' do
      let(:valid_attributes) { super().merge({ 'slug' => '' }) }

      include_contract 'should create the entity',
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes)    { super().merge({ 'slug' => 'example-slug' }) }
      let(:expected_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should create the entity',
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) },
        valid_attributes:    -> { valid_attributes }
    end
  end
end
