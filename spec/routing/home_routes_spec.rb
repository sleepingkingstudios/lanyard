# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{HomeController} routes", type: :routing do
  let(:controller) { 'home' }

  describe 'GET /' do
    it 'should route to RolesController#active' do
      expect(get: '/').to route_to(
        controller: 'roles',
        action:     'active'
      )
    end
  end

  describe 'DELETE /some/other/route' do
    it 'should not be routable' do
      expect(delete: '/some/other/route').not_to be_routable
    end
  end

  describe 'GET /some/other/route' do
    it 'should route to HomeController#not_found' do
      expect(get: '/some/other/route').to route_to(
        controller: controller,
        action:     'not_found',
        path:       'some/other/route'
      )
    end
  end

  describe 'PATCH /some/other/route' do
    it 'should not be routable' do
      expect(patch: '/some/other/route').not_to be_routable
    end
  end

  describe 'POST /some/other/route' do
    it 'should not be routable' do
      expect(post: '/some/other/route').not_to be_routable
    end
  end

  describe 'PUT /some/other/route' do
    it 'should not be routable' do
      expect(put: '/some/other/route').not_to be_routable
    end
  end
end
