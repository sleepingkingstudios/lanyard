# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's last_event_at and updated_at timestamps.
  class UpdateLastEvent < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role entities.
    # @param options [Hash] additional options for the command.
    def initialize(repository:, **options)
      super()

      @options    = options
      @repository = repository
    end

    # @return [Hash] additional options for the command.
    attr_reader :options

    # @return [Cuprum::Collections::Repository] the repository for Role
    #   entities.
    attr_reader :repository

    private

    def attributes_for(role:, role_event:)
      last_event_at = role_event.event_date&.beginning_of_day || role.created_at

      {
        last_event_at: last_event_at,
        updated_at:    Time.current
      }
    end

    def process(role:, role_event:)
      attributes = attributes_for(role: role, role_event: role_event)

      update_role(attributes: attributes, role: role)
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
