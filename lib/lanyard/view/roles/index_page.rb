# frozen_string_literal: true

module Lanyard::View::Roles
  # Page component for rendering the roles table.
  class IndexPage < Librum::Core::View::Pages::Resources::IndexPage
    TABS = [
      Librum::Core::View::Components::Tabs::TabDefinition.new(
        key:     'index',
        label:   'All Roles',
        url:     Rails.application.routes.url_helpers.roles_path,
        default: true
      ).freeze,
      Librum::Core::View::Components::Tabs::TabDefinition.new(
        key: 'active',
        url: Rails.application.routes.url_helpers.active_roles_path
      ).freeze,
      Librum::Core::View::Components::Tabs::TabDefinition.new(
        key: 'inactive',
        url: Rails.application.routes.url_helpers.inactive_roles_path
      ).freeze
    ].freeze
    private_constant :TABS

    private

    def tabs
      TABS
    end
  end
end
