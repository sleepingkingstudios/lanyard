# frozen_string_literal: true

# Event class for rejection of an application by the employer.
class RoleEvents::RejectedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::CLOSED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::APPLIED,
    Role::Statuses::INTERVIEWING,
    Role::Statuses::OFFERED
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Application rejected by employer'
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
