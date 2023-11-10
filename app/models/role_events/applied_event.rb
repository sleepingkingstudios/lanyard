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

# == Schema Information
#
# Table name: role_events
#
#  id         :uuid             not null, primary key
#  data       :jsonb            not null
#  event_date :date             not null
#  notes      :text             default(""), not null
#  slug       :string           default(""), not null
#  type       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :uuid
#
# Indexes
#
#  index_role_events_on_role_id_and_slug  (role_id,slug) UNIQUE
#  index_role_events_on_slug              (slug) UNIQUE
#
