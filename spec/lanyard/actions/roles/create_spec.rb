# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/create_contracts'

RSpec.describe Lanyard::Actions::Roles::Create, type: :action do
  include Cuprum::Rails::RSpec::Contracts::Actions::CreateContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      entity_class:         Role,
      permitted_attributes: %i[
        company_name
        cycle_id
        job_title
        slug
        source
      ]
    )
  end
  let(:cycle) { FactoryBot.create(:cycle) }
  let(:invalid_attributes) do
    { 'source' => 'confabulated' }
  end
  let(:valid_attributes) do
    {
      'source'    => Role::Sources::LINKEDIN,
      'cycle_id'  => cycle.id,
      'job_title' => 'Senior Executive Vice President of Title Generation'
    }
  end
  let(:current_time) { Time.current }
  let(:timestamp)    { current_time.strftime('%Y-%m-%d') }
  let(:expected_slug) do
    title = valid_attributes['job_title'].underscore.tr(' ', '-')

    "#{timestamp}-#{title}"
  end
  let(:expected_attributes) { { 'slug' => expected_slug } }

  before(:example) { allow(Time).to receive(:current).and_return(current_time) }

  include_contract 'should be a create action',
    invalid_attributes:             -> { invalid_attributes },
    valid_attributes:               -> { valid_attributes },
    expected_attributes_on_failure: lambda { |hsh|
      hsh.merge({ 'slug' => "#{timestamp}-0" })
    },
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
