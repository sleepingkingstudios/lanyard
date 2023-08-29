# frozen_string_literal: true

module Lanyard::Models::JobSearches
  # Converts start and end date parameters to Date objects.
  class NormalizeDates < Cuprum::Command
    PARTIAL_DATE_FORMAT = /\A\d{4}(-\d{2}(-\d{2})?)?\z/
    private_constant :PARTIAL_DATE_FORMAT

    private

    def normalize_end_date(attributes)
      return attributes unless attributes.key?('end_date')

      end_date = parse_date(attributes['end_date'])&.end_of_month

      attributes.merge('end_date' => end_date)
    end

    def normalize_start_date(attributes)
      return attributes unless attributes.key?('start_date')

      start_date = parse_date(attributes['start_date'])&.beginning_of_month

      attributes.merge('start_date' => start_date)
    end

    def parse_date(value)
      return unless value.is_a?(String) && value.match?(PARTIAL_DATE_FORMAT)

      value
        .split('-')
        .map(&:to_i)
        .then { |ary| Date.new(*ary) }
    rescue Date::Error
      nil
    end

    def process(attributes:)
      super()

      validate_attributes!(attributes)

      attributes
        .then { |hsh| normalize_start_date(hsh) }
        .then { |hsh| normalize_end_date(hsh) }
    end

    def validate_attributes!(attributes)
      return if attributes.is_a?(Hash)

      raise ArgumentError, 'attributes must be a Hash'
    end
  end
end
