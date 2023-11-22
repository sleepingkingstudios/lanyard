# frozen_string_literal: true

# Event class for declining an employer's offer.
class RoleEvents::DeclinedEvent < RoleEvents::StatusEvent
  # The status of the role after applying the event.
  STATUS = Role::Statuses::CLOSED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::OFFERED
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Offer declined'
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
