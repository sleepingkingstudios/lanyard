# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{RolesController} routes", type: :routing do
  include Librum::Core::RSpec::Contracts::RoutingContracts

  include_contract 'should route to view resource', 'roles'
end
