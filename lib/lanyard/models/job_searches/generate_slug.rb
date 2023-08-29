# frozen_string_literal: true

module Lanyard::Models::JobSearches
  # Generates a slug for a JobSearch model.
  class GenerateSlug < Cuprum::Command
    private

    def generate_slug_for(attributes)
      start_date = attributes['start_date']

      return '' if start_date.blank?

      attributes['start_date']&.strftime('%Y-%m')
    end

    def process(attributes:)
      super()

      validate_attributes!(attributes)

      generate_slug_for(attributes.stringify_keys)
    end

    def validate_attributes!(attributes)
      return if attributes.is_a?(Hash)

      raise ArgumentError, 'attributes must be a Hash'
    end
  end
end
