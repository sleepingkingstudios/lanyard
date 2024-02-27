# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{RolesController} routes", type: :routing do
  include Librum::Core::RSpec::Contracts::RoutingContracts

  let(:controller) { 'roles' }

  include_contract 'should route to view resource', 'roles'

  describe 'GET /roles/active.html' do
    it 'should route to Roles#index' do
      expect(get: '/roles/active.html').to route_to(
        controller: controller,
        action:     'active',
        format:     'html'
      )
    end
  end
end
