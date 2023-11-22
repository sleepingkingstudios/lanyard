# frozen_string_literal: true

# Event class for when a role is closed by the employer.
class RoleEvents::ClosedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::CLOSED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::NEW,
    Role::Statuses::APPLIED,
    Role::Statuses::INTERVIEWING,
    Role::Statuses::OFFERED,
    Role::Statuses::CLOSED
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Role closed by employer'
  end

  # (see RoleEvents::StatusEvent#status)
  def status
    STATUS
  end

  # (see RoleEvents::StatusEvent#valid_statuses)
  def valid_statuses
    VALID_STATUSES
  end
end
