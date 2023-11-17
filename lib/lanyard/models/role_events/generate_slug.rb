# frozen_string_literal: true

module Lanyard::Models::RoleEvents
  # Generates a slug for a RoleEvent model.
  class GenerateSlug < Cuprum::Command
    private

    def generate_slug_for(attributes)
      timestamp = resolve_timestamp(attributes)
      segments  = [
        timestamp&.iso8601,
        attributes['event_index'],
        RoleEvent.name_for(attributes['type']).underscore.tr('_', '-')
      ].compact

      segments.join('-')
    end

    def process(attributes:)
      super()

      validate_attributes!(attributes)

      generate_slug_for(attributes.stringify_keys)
    end

    def resolve_timestamp(attributes)
      return if attributes['event_date'].blank?

      attributes['event_date'].to_date
    rescue Date::Error
      nil
    end

    def validate_attributes!(attributes)
      return if attributes.is_a?(Hash)

      raise ArgumentError, 'attributes must be a Hash'
    end
  end
end
