# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's status and corresponding timestamp.
  class UpdateStatus < Lanyard::Models::Roles::UpdateLastEvent
    private

    def attributes_for(role:, role_event:)
      status = role_event.status

      super.merge(
        status:         status,
        "#{status}_at": Time.current
      )
    end
  end
end
