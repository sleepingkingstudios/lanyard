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

  describe 'PATCH /roles/apply.html' do
    let(:role_id) { 'monster-trainer' }

    it 'should route to Roles#apply' do # rubocop:disable RSpec/ExampleLength
      expect(patch: "/roles/#{role_id}/apply.html").to route_to(
        controller: controller,
        action:     'apply',
        format:     'html',
        id:         role_id
      )
    end
  end

  describe 'GET /roles/expiring.html' do
    it 'should route to Roles#index' do
      expect(get: '/roles/expiring.html').to route_to(
        controller: controller,
        action:     'expiring',
        format:     'html'
      )
    end
  end

  describe 'GET /roles/inactive.html' do
    it 'should route to Roles#index' do
      expect(get: '/roles/inactive.html').to route_to(
        controller: controller,
        action:     'inactive',
        format:     'html'
      )
    end
  end
end
