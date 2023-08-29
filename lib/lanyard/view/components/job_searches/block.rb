# frozen_string_literal: true

module Lanyard::View::Components::JobSearches
  # Renders a single JobSearch record.
  class Block < ViewComponent::Base
    FIELDS = [
      { key: 'start_date' }.freeze,
      {
        key:     'end_date',
        default: '—'
      }.freeze
    ].freeze
    private_constant :FIELDS

    # @param data [JobSearch] the publisher to display.
    def initialize(data:, **)
      super()

      @data = data
    end

    # @return [JobSearch] the publisher to display.
    attr_reader :data

    # @return [Array<DataField::FieldDefinition>] the configuration objects for
    #   rendering the publisher.
    def fields
      FIELDS
    end
  end
end
