# frozen_string_literal: true

module Lanyard::View::RoleEvents
  # Renders a single RoleEvent
  class Block < ViewComponent::Base
    FIELDS = [
      { key: 'name' }.freeze,
      { key: 'slug' }.freeze,
      {
        key:   'event_date',
        value: ->(item) { item.event_date.iso8601 }
      }.freeze
    ].freeze
    private_constant :FIELDS

    # @param data [RoleEvent] the event to display.
    def initialize(data:, **)
      super()

      @data = data
    end

    # @return [RoleEvent] the event to display.
    attr_reader :data

    # @return [Array<DataField::FieldDefinition>] the configuration objects for
    #   rendering the event.
    def fields
      FIELDS
    end
  end
end
