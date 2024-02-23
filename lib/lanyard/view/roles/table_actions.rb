# frozen_string_literal: true

module Lanyard::View::Roles
  # Renders actions for a roles table.
  class TableActions < Librum::Core::View::Components::Resources::TableActions
    private

    def build_events_link
      Librum::Core::View::Components::Link.new(
        "#{routes.show_path(data['slug'])}/events",
        button:     true,
        class_name: 'is-small',
        color:      'primary',
        label:      'Events',
        light:      true
      )
    end

    def render_events_link
      render(build_events_link)
    end
  end
end
