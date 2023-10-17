# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{CyclesController} routes", type: :routing do
  include Librum::Core::RSpec::Contracts::RoutingContracts

  include_contract 'should route to view resource', 'cycles'
end
