# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's status and corresponding timestamp.
  class UpdateStatus < Lanyard::Models::Roles::UpdateLastEvent
    private

    def attributes_for(role:, role_event:)
      return super unless update_status?(role: role, role_event: role_event)

      status = role_event.status

      super.merge(
        status:         status,
        "#{status}_at": Time.current
      )
    end

    def update_status?(role:, role_event:)
      return true unless options[:update_status].respond_to?(:call)

      options[:update_status].call(role: role, role_event: role_event)
    end
  end
end
