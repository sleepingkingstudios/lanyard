# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{RoleEventsController} routes", type: :routing do
  include Librum::Core::RSpec::Contracts::RoutingContracts

  include_contract 'should route to view resource',
    'roles/example-role/events',
    controller: 'role_events',
    only:       %i[index new create show edit update],
    wildcards:  { 'role_id' => 'example-role' }
end
