# frozen_string_literal: true

# Abstract class for an event that changes a role's status.
class RoleEvents::StatusEvent < RoleEvent
  # Exception raised when calling an abstract method.
  class AbstractEventError < StandardError; end

  class << self
    # (see RoleEvent.abstract_event?)
    def abstract_event?
      name == 'RoleEvents::StatusEvent'
    end

    # (see RoleEvent.valid_for?)
    def valid_for?(role)
      self::VALID_STATUSES.include?(role.status)
    end
  end

  # (see RoleEvent#default_summary)
  def default_summary
    'Generic status event'
  end

  # @return [String] the status of the role after applying the event.
  #
  # @raise [AbstractEventError] if the status is not defined.
  def status
    raise AbstractEventError, "#{self.class.name}#status is an abstract method"
  end

  # Generates a command for updating the role status.
  #
  # @param repository [Cuprum::Collections::Repository] the repository for
  #   Role entities.
  #
  # @return [Cuprum::Command] the generated command.
  def update_role(repository:)
    Lanyard::Models::Roles::UpdateStatus.new(repository: repository)
  end

  # @return [Array<String>] the valid statuses for a role before applying the
  #   event.
  def valid_statuses
    raise AbstractEventError,
      "#{self.class.name}#valid_statuses is an abstract method"
  end

  # Generates a command for validating the role transition.
  #
  # @param repository [Cuprum::Collections::Repository] the repository for
  #   Role entities.
  #
  # @return [Cuprum::Command] the generated command.
  def validate_role(repository:)
    Lanyard::Models::RoleEvents::ValidateStatusTransition.new(
      repository:     repository,
      status:         status,
      valid_statuses: valid_statuses
    )
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
