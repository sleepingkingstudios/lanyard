# frozen_string_literal: true

module Lanyard::Actions::RoleEvents::Concerns
  # Action helper for generating the index for a role event.
  module GenerateIndex
    private

    def create_entity(attributes:)
      attributes = attributes.merge({
        'event_index' => step { generate_index(attributes) }
      })

      super
    end

    def events_collection
      repository.find_or_create(
        entity_class:   RoleEvent,
        qualified_name: 'role_events'
      )
    end

    def generate_index(attributes)
      return nil if attributes['role_id'].blank?

      events_collection
        .query
        .where { { 'role_id' => attributes['role_id'] } }
        .count
    end
  end
end
