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

# == Schema Information
#
# Table name: role_events
#
#  id          :uuid             not null, primary key
#  data        :jsonb            not null
#  event_date  :date             not null
#  event_index :integer          not null
#  notes       :text             default(""), not null
#  slug        :string           default(""), not null
#  type        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role_id     :uuid
#
# Indexes
#
#  index_role_events_on_role_id_and_event_index  (role_id,event_index) UNIQUE
#  index_role_events_on_role_id_and_slug         (role_id,slug) UNIQUE
#
