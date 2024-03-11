# frozen_string_literal: true

module Lanyard::Import::Roles
  # Parses a notes list into role attributes.
  class ParseNotes < Cuprum::Command
    private

    def normalize(item)
      item.strip.downcase.tr(' ', '_').tr('-', '_')
    end

    def parse_contract_type(items, attributes, normalized)
      Role::ContractTypes.each_value do |contract_type|
        next unless normalized.include?(contract_type)

        attributes = attributes.merge('contract_type' => contract_type)
        items      = items.reject { |item| normalize(item) == contract_type }
      end

      [items, attributes]
    end

    def parse_location_type(items, attributes, normalized) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      Role::LocationTypes.each_value do |location_type|
        if normalized.include?(location_type)
          attributes = attributes.merge('location_type' => location_type)
          items      = items.reject { |item| normalize(item) == location_type }
        elsif normalized.any? { |item| item.start_with?(location_type) }
          match      =
            items.find { |item| normalize(item).start_with?(location_type) }
          attributes = attributes.merge(
            'location'      => strip_location_type(match, location_type),
            'location_type' => location_type
          )
          items =
            items.reject { |item| normalize(item).start_with?(location_type) }
        end
      end

      [items, attributes]
    end

    def process(*items)
      normalized = Set.new(items.map { |item| normalize(item) })
      attributes = {}

      items, attributes = parse_contract_type(items, attributes, normalized)
      items, attributes = parse_location_type(items, attributes, normalized)

      unless items.empty?
        attributes = attributes.merge('notes' => items.join("\n\n"))
      end

      attributes
    end

    def strip_location_type(match, location_type)
      match
        .strip
        .then { |str| str[location_type.length..] }
        .then { |str| str.sub(/\A[\- ]+/, '') }
    end
  end
end
