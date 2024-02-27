# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'
require 'cuprum/rails/rspec/contracts/actions/index_contracts'

RSpec.describe Lanyard::Actions::Roles::Expiring do
  include Cuprum::Rails::RSpec::Contracts::Actions::IndexContracts

  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      default_order: :slug,
      entity_class:  Role
    )
  end
  let(:previous_cycle) { FactoryBot.build(:cycle, year: 1999) }
  let(:previous_role) do
    FactoryBot.build(:role, :offered, cycle: previous_cycle)
  end
  let(:current_cycle) { FactoryBot.build(:cycle, year: 2000) }
  let(:roles) do
    [
      FactoryBot.build(
        :role,
        :new,
        cycle:         current_cycle,
        last_event_at: 7.weeks.ago
      ),
      FactoryBot.build(
        :role,
        :applied,
        cycle:         current_cycle,
        last_event_at: 6.weeks.ago
      ),
      FactoryBot.build(
        :role,
        :interviewing,
        cycle:         current_cycle,
        last_event_at: 5.weeks.ago
      ),
      FactoryBot.build(
        :role,
        :offered,
        cycle:         current_cycle,
        last_event_at: 4.weeks.ago
      ),
      FactoryBot.build(
        :role,
        :accepted,
        cycle:         current_cycle,
        last_event_at: 3.weeks.ago
      )
    ]
  end
  let(:recent_role) do
    FactoryBot.build(
      :role,
      :new,
      cycle:         current_cycle,
      last_event_at: 1.week.ago
    )
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
    previous_cycle.save!
    current_cycle.save!

    previous_role.save!
    recent_role.save!
    roles.each(&:save!)
  end

  include_contract 'should be an index action',
    existing_entities:         -> { roles },
    expected_value_on_success: -> { expected_value }
end
