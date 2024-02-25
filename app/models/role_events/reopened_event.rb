# frozen_string_literal: true

# Event class for reverting to the last open status.
class RoleEvents::ReopenedEvent < RoleEvent
  class << self
    # (see RoleEvent.valid_for?)
    def valid_for?(role)
      role.status == Role::Statuses::CLOSED
    end
  end

  # (see RoleEvent#default_summary)
  def default_summary
    'Reopened the closed role'
  end

  # Generates a command for updating the role status.
  #
  # @return [Cuprum::Command] the generated command.
  def update_status(repository:)
    Lanyard::Models::Roles::Reopen.new(repository: repository)
  end

  # Generates a command for validating the role transition.
  #
  # @return [Cuprum::Command] the generated command.
  def validate_status_transition
    Cuprum::Command.new { |_| nil }
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
