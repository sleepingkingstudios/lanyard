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
      permitted_attributes: %i[
        role_id
        notes
        slug
        type
      ],
      resource_class:       RoleEvent
    )
  end
  let(:invalid_attributes) do
    { 'role_id' => nil }
  end
  let(:valid_attributes) do
    { 'notes' => 'This job rocks!' }
  end
  let(:current_time) { Time.current }
  let(:timestamp)    { current_time.strftime('%Y-%m-%d') }
  let(:event)        { FactoryBot.create(:event, :with_role) }

  before(:example) { allow(Time).to receive(:current).and_return(current_time) }

  include_contract 'update action contract',
    existing_entity:    -> { event },
    invalid_attributes: -> { invalid_attributes },
    valid_attributes:   -> { valid_attributes },
    primary_key_value:  -> { SecureRandom.uuid } \
  do
    describe 'with id: a slug' do
      let(:params) do
        { 'id' => event.slug, 'role_event' => valid_attributes }
      end

      include_contract 'should update the entity',
        existing_entity:  -> { event },
        valid_attributes: -> { valid_attributes },
        params:           -> { params }
    end

    describe 'with slug: an empty String' do
      let(:valid_attributes)    { super().merge({ 'slug' => '' }) }
      let(:current_time)        { Time.current }
      let(:timestamp)           { current_time.strftime('%Y-%m-%d') }
      let(:expected_slug)       { "#{timestamp}-event" }
      let(:expected_attributes) { { 'slug' => expected_slug } }

      include_contract 'should update the entity',
        existing_entity:     -> { event },
        valid_attributes:    -> { valid_attributes },
        expected_attributes: ->(hsh) { hsh.merge(expected_attributes) }
    end

    describe 'with slug: a valid slug' do
      let(:valid_attributes) { super().merge({ 'slug' => 'example-slug' }) }

      include_contract 'should update the entity',
        existing_entity:  -> { event },
        valid_attributes: -> { valid_attributes }
    end
  end
end
