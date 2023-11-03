# frozen_string_literal: true

module Lanyard::Actions::RoleEvents
  # Create action for RoleEvent controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::RoleEvents::Concerns::GenerateSlug

    private

    def create_entity(attributes:)
      transaction do
        role_event = step { super }

        next role_event unless role_event.is_a?(RoleEvents::StatusEvent)

        role = step { find_role(role_event: role_event) }
        role = step { update_role(role: role, role_event: role_event) }
      end
    end

    def find_role(role_event:)
      roles_collection.find_one.call(primary_key: role_event.role_id)
    end

    def roles_collection
      repository.find_or_create(entity_class: Role)
    end

    def update_role(role:, role_event:)
      step { role_event.validate_status_transition.call(role: role) }

      role_event.update_status(repository: repository).call(role: role)
    end
  end
end
