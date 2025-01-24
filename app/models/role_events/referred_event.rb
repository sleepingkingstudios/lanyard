# frozen_string_literal: true

# Event class for applying directly to a role.
class RoleEvents::ReferredEvent < RoleEvents::StatusEvent
  ROLE_IS_NEW = ->(role:, **) { role.status == Role::Statuses::NEW }
  private_constant :ROLE_IS_NEW

  # The status of the role after applying the event.
  STATUS = Role::Statuses::APPLIED

  # The valid statuses for a role before applying the event.
  VALID_STATUSES = [
    Role::Statuses::NEW,
    Role::Statuses::APPLIED,
    Role::Statuses::INTERVIEWING
  ].freeze

  # (see RoleEvent#default_summary)
  def default_summary
    'Referred for the role'
  end

  # (see RoleEvents::StatusEvent#status)
  def status
    STATUS
  end

  # (see RoleEvents::StatusEvent#update_role)
  def update_role(repository:)
    Lanyard::Models::Roles::UpdateStatus.new(
      repository:    repository,
      update_status: ROLE_IS_NEW
    )
  end

  # (see RoleEvents::StatusEvent#valid_statuses)
  def valid_statuses
    VALID_STATUSES
  end
end
