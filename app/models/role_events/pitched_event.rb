# frozen_string_literal: true

# Event class for applying to a role via recruiter.
class RoleEvents::PitchedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::APPLIED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::NEW
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Pitched for the role by recruiter'
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
