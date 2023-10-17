# frozen_string_literal: true

module Lanyard::View::Components::Cycles
  # Renders a table of Cycle records.
  class Table < Librum::Core::View::Components::Resources::Table
    COLUMNS = lambda { # rubocop:disable Metrics/BlockLength
      [
        {
          key:   'name',
          value: lambda { |item|
            Librum::Core::View::Components::Link.new(
              "/cycles/#{item.slug}",
              label: item.name
            )
          }
        },
        {
          key:  'active',
          type: :boolean
        },
        {
          key:   'ui_eligible',
          label: 'UI Eligible',
          type:  :boolean
        },
        {
          key:      'actions',
          label:    ' ',
          resource: resource,
          type:     :actions
        }
      ].freeze
    }.freeze
    private_constant :COLUMNS

    # @param data [Array<Cycle>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    def initialize(data:, resource:)
      super(
        columns:  COLUMNS,
        data:     data,
        resource: resource
      )
    end
  end
end
