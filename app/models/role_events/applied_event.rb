# frozen_string_literal: true

# Event class for applying directly to a role.
class RoleEvents::AppliedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::APPLIED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::NEW
  ].freeze

  # (see RoleEvents::StatusEvent#status)
  def status
    STATUS
  end

  # (see RoleEvents::StatusEvent#valid_statuses)
  def valid_statuses
    VALID_STATUSES
  end
end
