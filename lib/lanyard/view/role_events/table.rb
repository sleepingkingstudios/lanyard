# frozen_string_literal: true

module Lanyard::View::RoleEvents
  # Renders a table of RoleEvent records.
  class Table < Librum::Core::View::Components::Resources::Table
    COLUMNS = lambda { # rubocop:disable Metrics/BlockLength
      [
        {
          key:   'name',
          label: 'Event',
          url:   ->(item) { "/roles/#{item.role.slug}/events/#{item.slug}" },
          type:  :link
        }.freeze,
        {
          key:   'event_date',
          label: 'Date',
          value: ->(item) { item.event_date.iso8601 }
        }.freeze,
        {
          key:      'summary',
          label:    'Summary',
          value:    ->(item) { item.summary },
          truncate: 60
        }.freeze,
        {
          key:      'actions',
          label:    ' ',
          resource: resource,
          routes:   routes,
          type:     :actions
        }.freeze
      ]
    }.freeze

    # @param data [Array<RoleEvent>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    # @param routes [Cuprum::Rails::Routes] the routes for the resource.
    def initialize(data:, resource:, routes:, **)
      super(
        columns:  COLUMNS,
        data:     data,
        resource: resource,
        routes:   routes,
        **
      )
    end
  end
end
