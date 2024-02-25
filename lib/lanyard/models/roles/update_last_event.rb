# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's last_event_at and updated_at timestamps.
  class UpdateLastEvent < Cuprum::Command
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

    def attributes_for(role:)
      {
        last_event_at: last_event_at(role: role),
        updated_at:    Time.current
      }
    end

    def last_event_at(role:)
      event = last_event_for(role: role)

      event&.event_date&.beginning_of_day || role.created_at
    end

    def last_event_for(role:)
      role_events_collection
        .find_matching
        .call(
          limit: 1,
          order: { event_date: :desc },
          where: { role_id: role.id }
        )
        .value
        &.first
    end

    def process(role:)
      attributes = attributes_for(role: role)

      update_role(attributes: attributes, role: role)
    end

    def role_events_collection
      @role_events_collection ||=
        repository.find_or_create(entity_class: RoleEvent)
    end

    def roles_collection
      @roles_collection ||=
        repository.find_or_create(entity_class: Role)
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
