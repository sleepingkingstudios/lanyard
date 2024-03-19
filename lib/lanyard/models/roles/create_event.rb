# frozen_string_literal: true

require 'cuprum/rails/transaction'

module Lanyard::Models::Roles
  # Adds a new event to the role.
  class CreateEvent < Cuprum::Command
    def initialize(repository:)
      super()

      @repository = repository
    end

    attr_reader :repository

    private

    def build_event(attributes:, role:)
      attributes = attributes.merge(
        event_index: event_index(role: role),
        role_id:     role.id
      )
      attributes = attributes.merge(
        slug: step { generate_slug(attributes: attributes) }
      )

      role_events_collection.build_one.call(attributes: attributes)
    end

    def event_index(role:)
      role_events_collection
        .query
        .where(role_id: role.id)
        .count
    end

    def generate_slug(attributes:)
      Lanyard::Models::RoleEvents::GenerateSlug.new.call(attributes: attributes)
    end

    def insert_event(role_event:)
      role_events_collection.insert_one.call(entity: role_event)
    end

    def process(attributes:, role:) # rubocop:disable Metrics/MethodLength
      transaction do
        role_event = step { build_event(attributes: attributes, role: role) }

        step { validate_event(role_event: role_event) }

        step { validate_role(role_event: role_event) }

        step { insert_event(role_event: role_event) }

        step { update_role(role_event: role_event) }

        success({
          'role'       => role,
          'role_event' => role_event
        })
      end
    end

    def role_events_collection
      repository.find_or_create(entity_class: RoleEvent)
    end

    def transaction(&block)
      Cuprum::Rails::Transaction.new.call(&block)
    end

    def update_role(role_event:)
      role_event
        .update_role(repository: repository)
        .call(role: role_event.role, role_event: role_event)
    end

    def validate_event(role_event:)
      role_events_collection.validate_one.call(entity: role_event)
    end

    def validate_role(role_event:)
      role_event
        .validate_role(repository: repository)
        .call(role: role_event.role)
    end
  end
end
