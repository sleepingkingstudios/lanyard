# frozen_string_literal: true

# Basic controller for showing the Home page.
class HomeController < ViewController
  def self.breadcrumbs
    @breadcrumbs ||= [{ active: true, label: 'Home', url: '/' }]
  end

  def self.resource
    @resource ||=
      Librum::Core::Resources::BaseResource.new(resource_name: 'home')
  end

  middleware Librum::Core::Actions::View::Middleware::PageBreadcrumbs.new(
    breadcrumbs: breadcrumbs
  )

  action :not_found, Librum::Core::Actions::View::NotFound, member: false
end
