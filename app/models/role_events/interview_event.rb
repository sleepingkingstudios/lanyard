# frozen_string_literal: true

# Event class for interviewing for a role.
class RoleEvents::InterviewEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::INTERVIEWING

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::APPLIED,
    Role::Statuses::INTERVIEWING
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Interviewed for the role'
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
