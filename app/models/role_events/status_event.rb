# frozen_string_literal: true

# Abstract class for an event that changes a role's status.
class RoleEvents::StatusEvent < RoleEvent
  # Exception raised when calling an abstract method.
  class AbstractEventError < StandardError; end

  # @return [String] the status of the role after applying the event.
  #
  # @raise [AbstractEventError] if the status is not defined.
  def status
    raise AbstractEventError, "#{self.class.name}#status is an abstract method"
  end

  # Generates a command for updating the role status.
  #
  # @return [Cuprum::Command] the generated command.
  def update_status(repository:)
    Lanyard::Models::Roles::UpdateStatus.new(
      repository: repository,
      status:     status
    )
  end

  # @return [Array<String>] the valid statuses for a role before applying the
  #   event.
  def valid_statuses
    raise AbstractEventError,
      "#{self.class.name}#valid_statuses is an abstract method"
  end

  # Generates a command for validating the role transition.
  #
  # @return [Cuprum::Command] the generated command.
  def validate_status_transition
    Lanyard::Models::Roles::ValidateStatusTransition.new(
      status:         status,
      valid_statuses: valid_statuses
    )
  end
end
