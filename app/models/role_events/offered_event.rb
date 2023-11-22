# frozen_string_literal: true

# Event class for when an offer is extended by the employer.
class RoleEvents::OfferedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::OFFERED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::INTERVIEWING
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Offer extended by employer'
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
