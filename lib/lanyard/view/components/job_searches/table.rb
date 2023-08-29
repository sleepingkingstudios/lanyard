# frozen_string_literal: true

module Lanyard::View::Components::JobSearches
  # Renders a table of JobSearch records.
  class Table < Librum::Core::View::Components::Resources::Table
    COLUMNS_FOR = lambda { |resource|
      [
        {
          key:   'start_date',
          value: lambda { |item|
            Librum::Core::View::Components::Link.new(
              "/job-searches/#{item.slug}",
              label: item.start_date.strftime('%Y-%m')
            )
          }
        }.freeze,
        {
          key:     'end_date',
          default: '—'
        }.freeze,
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

    # @param data [Array<JobSearch>] the table data to render.
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
