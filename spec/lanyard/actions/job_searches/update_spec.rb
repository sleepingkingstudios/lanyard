# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/update_contracts'

RSpec.describe Lanyard::Actions::JobSearches::Update, type: :action do
  include Cuprum::Rails::RSpec::Actions::UpdateContracts

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
    { 'start_date' => '2010-12' }
  end
  let(:expected_attributes) do
    { 'start_date' => Date.new(2010, 12, 1) }
  end
  let(:job_search) { FactoryBot.create(:job_search) }

  before(:example) { job_search.save }

  include_contract 'update action contract',
    existing_entity:     -> { job_search },
    invalid_attributes:  -> { invalid_attributes },
    valid_attributes:    -> { valid_attributes },
    expected_attributes: -> { expected_attributes },
    primary_key_value:   -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) do
        { 'id' => job_search.slug, 'job_search' => valid_attributes }
      end

      include_contract 'should update the entity',
        existing_entity:     -> { job_search },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: -> { expected_attributes },
        params:              -> { params }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes)    { super().merge({ 'slug' => '' }) }
      let(:expected_attributes) { super().merge({ 'slug' => '2010-12' }) }

      include_contract 'should update the entity',
        existing_entity:     -> { job_search },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:     -> { job_search },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) },
        valid_attributes:    -> { valid_attributes }
    end
  end
end
