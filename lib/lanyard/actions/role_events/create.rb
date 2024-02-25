# frozen_string_literal: true

module Lanyard::Actions::RoleEvents
  # Create action for RoleEvent controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::RoleEvents::Concerns::GenerateSlug
    prepend Lanyard::Actions::RoleEvents::Concerns::GenerateIndex

    private

    def create_entity(attributes:)
      transaction do
        role_event = step { super }

        step { validate_role(role_event: role_event) }

        step { update_role(role_event: role_event) }
      end
    end

    def update_role(role_event:)
      role_event
        .update_role(repository: repository)
        .call(role: role_event.role)
    end

    def validate_role(role_event:)
      result =
        role_event
        .validate_role(repository: repository)
        .call(role: role_event.role)

      return result if result.success?

      Cuprum::Rails::Result.new(
        **result.properties,
        value: build_response
      )
    end
  end
end
