# frozen_string_literal: true

module Lanyard::View::Components::Cycles
  # Renders a single cycle record.
  class Block < ViewComponent::Base
    FIELDS = [
      { key: 'name' }.freeze,
      { key: 'slug' }.freeze,
      { key: 'year' }.freeze,
      {
        key:   'season',
        value: ->(item) { item.season.titleize }
      }
    ].freeze
    private_constant :FIELDS

    # @param data [Cycle] the cycle to display.
    def initialize(data:, **)
      super()

      @data = data
    end

    # @return [Cycle] the cycle to display.
    attr_reader :data

    # @return [Array<DataField::FieldDefinition>] the configuration objects for
    #   rendering the cycle.
    def fields
      FIELDS
    end
  end
end
