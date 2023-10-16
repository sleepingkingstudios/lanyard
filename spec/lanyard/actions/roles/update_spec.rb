# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/actions/update_contracts'

RSpec.describe Lanyard::Actions::Roles::Update do
  include Cuprum::Rails::RSpec::Actions::UpdateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      permitted_attributes: %i[
        company_name
        cycle_id
        job_title
        slug
        source
      ],
      resource_class:       Role
    )
  end
  let(:invalid_attributes) do
    { 'source' => 'confabulated' }
  end
  let(:valid_attributes) do
    {
      'source'    => Role::Sources::LINKEDIN,
      'job_title' => 'Senior Executive Vice President of Title Generation'
    }
  end
  let(:role) { FactoryBot.create(:role, :with_cycle) }

  include_contract 'update action contract',
    existing_entity:    -> { role },
    invalid_attributes: -> { invalid_attributes },
    valid_attributes:   -> { valid_attributes },
    primary_key_value:  -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) do
        { 'id' => role.slug, 'role' => valid_attributes }
      end

      include_contract 'should update the entity',
        existing_entity:  -> { role },
        valid_attributes: -> { valid_attributes },
        params:           -> { params }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes) { super().merge({ 'slug' => '' }) }
      let(:current_time)     { Time.current }
      let(:timestamp)        { current_time.strftime('%Y-%m-%d') }
      let(:expected_slug) do
        title = valid_attributes['job_title'].underscore.tr(' ', '-')

        "#{timestamp}-#{title}"
      end
      let(:expected_attributes) { { 'slug' => expected_slug } }

      include_contract 'should update the entity',
        existing_entity:     -> { role },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:  -> { role },
        valid_attributes: -> { valid_attributes }
    end
  end
end
