# frozen_string_literal: true

module Lanyard::Models::Roles
  # Reopens a closed role, reverting to the previous status.
  class Reopen < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role and RoleEvent entities.
    def initialize(repository:)
      super()

      @repository = repository
    end

    # @return [Cuprum::Collections::Repository] the repository for Role and
    #   RoleEvent entities.
    attr_reader :repository

    private

    def previous_events_for(role:)
      role_events_collection
        .find_matching
        .call(order: { slug: :desc }) do
          { 'role_id' => role.id }
        end
    end

    def previous_status_for(role:)
      events = step { previous_events_for(role: role) }
      event  = events.find do |item|
        item.is_a?(RoleEvents::StatusEvent) &&
          item.status != Role::Statuses::CLOSED
      end

      return Role::Statuses::NEW if event.blank?

      event.status
    end

    def process(role:)
      status     = step { previous_status_for(role: role) }
      attributes = { 'status' => status }

      update_role(attributes: attributes, role: role)
    end

    def role_events_collection
      @role_events_collection ||= repository.find_or_create(
        entity_class:   RoleEvent,
        qualified_name: 'role_events'
      )
    end

    def roles_collection
      @roles_collection ||= repository.find_or_create(entity_class: Role)
    end

    def update_role(attributes:, role:)
      assigned = step do
        roles_collection.assign_one.call(attributes: attributes, entity: role)
      end

      step { roles_collection.validate_one.call(entity: assigned) }

      step { roles_collection.update_one.call(entity: assigned) }
    end
  end
end
