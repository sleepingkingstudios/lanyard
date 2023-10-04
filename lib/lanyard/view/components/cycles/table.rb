# frozen_string_literal: true

module Lanyard::View::Components::Cycles
  # Renders a table of Cycle records.
  class Table < Librum::Core::View::Components::Resources::Table
    COLUMNS_FOR = lambda { |resource|
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
          key:   'actions',
          label: ' ',
          value: lambda { |item|
            Librum::Core::View::Components::Resources::TableActions.new(
              data:     item,
              resource: resource
            )
          }
        }
      ].freeze
    }.freeze
    private_constant :COLUMNS_FOR

    # @param data [Array<Cycle>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    def initialize(data:, resource:)
      super(
        columns:  COLUMNS_FOR.call(resource),
        data:     data,
        resource: resource
      )
    end
  end
end
