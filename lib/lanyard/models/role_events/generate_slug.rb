# frozen_string_literal: true

module Lanyard::Models::RoleEvents
  # Generates a slug for a RoleEvent model.
  class GenerateSlug < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role entities.
    def initialize(repository:)
      super()

      @repository = repository
    end

    # @return [Cuprum::Collections::Repository] the repository for Role
    #   entities.
    attr_reader :repository

    private

    def events_collection
      @events_collection ||= repository.find_or_create(entity_class: RoleEvent)
    end

    def generate_event_name(attributes)
      return 'event' if attributes['type'].blank?

      attributes
        .fetch('type', '')
        .split('::')
        .last
        .sub(/Event\z/, '')
        .underscore
        .tr('_', '-')
    end

    def generate_ordinal(attributes)
      ordinal_query(attributes)
        .count
        .nonzero?
    end

    def generate_slug_for(attributes)
      segments = [
        generate_timestamp,
        generate_event_name(attributes),
        generate_ordinal(attributes)
      ].compact

      segments << role_index if segments.size == 1

      segments.join('-')
    end

    def generate_timestamp
      Time.current.strftime('%Y-%m-%d')
    end

    def ordinal_query(attributes)
      events_collection
        .query
        .where do
          {
            created_at: gte(Time.current.beginning_of_day),
            role_id:    attributes['role_id'],
            type:       attributes.fetch('type', '')
          }
        end
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
