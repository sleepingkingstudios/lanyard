# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/index_contracts'

RSpec.describe Lanyard::Actions::Roles::Active do
  include Cuprum::Rails::RSpec::Contracts::Actions::IndexContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      default_order: :slug,
      entity_class:  Role
    )
  end
  let(:cycle) { FactoryBot.build(:cycle) }
  let(:roles) do
    [
      FactoryBot.build(:role, :new, cycle: cycle),
      FactoryBot.build(:role, :applied, cycle: cycle),
      FactoryBot.build(:role, :interviewing, cycle: cycle),
      FactoryBot.build(:role, :offered, cycle: cycle),
      FactoryBot.build(:role, :accepted, cycle: cycle)
    ]
  end
  let(:expected_roles) do
    roles
      .reject { |role| role.status == Role::Statuses::CLOSED }
      .sort_by(&:slug)
  end
  let(:expected_value) do
    { 'roles' => expected_roles }
  end

  before(:example) do
    cycle.save!

    roles.each(&:save!)
  end

  include_contract 'should be an index action',
    existing_entities:         -> { roles },
    expected_value_on_success: -> { expected_value }
end
