# frozen_string_literal: true

require 'cuprum/error'

module Lanyard::Import::Errors
  # Error returned when unable to parse an imported record.
  class ParseError < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'lanyard.import.errors.parse_error'

    # @param entity_class [Class] the class of the intended record, if any.
    #   Defaults to nil.
    # @param message [String] an additional message to display in the error.
    # @param raw_value [String] the unparsed value.
    def initialize(raw_value:, entity_class: nil, message: nil)
      message = generate_message(entity_class: entity_class, message: message)

      super(
        entity_class: entity_class,
        raw_value:    raw_value,
        message:      message
      )

      @entity_class = entity_class
      @raw_value    = raw_value
    end

    # @return [Class] the class of the intended record, if any.
    attr_reader :entity_class

    # @return [String] the unparsed value.
    attr_reader :raw_value

    private

    def as_json_data
      return { 'raw_value' => raw_value } unless entity_class

      {
        'entity_class' => entity_class.name,
        'raw_value'    => raw_value
      }
    end

    def generate_message(entity_class:, message:)
      str = 'Unable to parse value'
      str += " as #{entity_class}" if entity_class
      str += " - #{message}"       if message
      str
    end
  end
end
