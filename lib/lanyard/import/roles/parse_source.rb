# frozen_string_literal: true

module Lanyard::Import::Roles
  # Parses a source representation into role attributes.
  class ParseSource < Cuprum::Command
    private

    def match_email(raw_value)
      return unless raw_value.include?('@')

      {
        'source'         => Role::Sources::EMAIL,
        'source_details' => raw_value
      }
    end

    def match_prefix(raw_value) # rubocop:disable Metrics/MethodLength
      normalized = raw_value.downcase

      Role::Sources.each_value do |value|
        next unless normalized.start_with?(value)

        remainder = raw_value[value.length..].sub(/\A[\- ]+/, '')

        return { 'source' => value } if remainder.empty?

        return {
          'source'         => value,
          'source_details' => remainder
        }
      end

      nil
    end

    def match_raw(raw_value)
      return {} if raw_value.blank?

      { 'source_details' => raw_value }
    end

    def match_url(raw_value)
      source = match_website(raw_value)

      return unless source

      {
        'source'         => source,
        'source_details' => raw_value
      }
    end

    def match_website(raw_value)
      if raw_value.include?('dice.com')
        Role::Sources::DICE
      elsif raw_value.include?('hired.com')
        Role::Sources::HIRED
      elsif raw_value.include?('indeed.com')
        Role::Sources::INDEED
      end
    end

    def process(attributes:)
      return attributes if attributes['source'].blank?

      raw_value   = attributes['source'].strip
      attributes  = attributes.except('source')
      source_hash =
        match_prefix(raw_value) ||
        match_email(raw_value) ||
        match_url(raw_value) ||
        match_raw(raw_value)

      success(attributes.merge(source_hash))
    end
  end
end
