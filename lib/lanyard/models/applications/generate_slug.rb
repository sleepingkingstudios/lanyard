# frozen_string_literal: true

module Lanyard::Models::Applications
  # Generates a slug for an Application model.
  class GenerateSlug < Cuprum::Command
    private

    def application_index
      Application
        .where('created_at > ?', Time.current.beginning_of_day)
        .count
    end

    def format_value(value)
      return if value.blank?

      I18n
        .transliterate(value)
        .underscore
        .gsub(/[^a-z0-9]+/, '-')
        .sub(/\A-+/, '')
        .sub(/-+\z/, '')
    end

    def generate_slug_for(attributes)
      segments = [
        generate_timestamp,
        format_value(attributes['company_name']),
        format_value(attributes['job_title'])
      ].compact

      segments << application_index if segments.size == 1

      segments.join('-')
    end

    def generate_timestamp
      Time.current.strftime('%Y-%m-%d')
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
