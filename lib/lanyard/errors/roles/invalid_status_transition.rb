# frozen_string_literal: true

module Lanyard::Errors::Roles
  # Error returned for a role event with an invalid status.
  class InvalidStatusTransition < Lanyard::Errors::Roles::StatusError
    # Short string used to identify the type of error.
    TYPE = 'lanyard.errors.role_events.invalid_status_transition'

    # @param current_status [String] the current status of the role.
    # @param status [String] the invalid status.
    # @param valid_statuses [Array<String>] the valid statuses for the
    #   attempted transition.
    def initialize(current_status:, status:, valid_statuses:)
      @current_status = current_status
      @valid_statuses = valid_statuses

      message = default_message_for(status: status)

      super(message: message, status: status)
    end

    # @return [String] the current status of the role.
    attr_reader :current_status

    # @return [Array<String>] the valid statuses for the attempted transition.
    attr_reader :valid_statuses

    private

    def as_json_data
      super.merge(
        'current_status' => current_status.to_s,
        'valid_statuses' => valid_statuses.map(&:to_s)
      )
    end

    def default_message_for(status:)
      if current_status == status
        return "role is already in status #{status.inspect}"
      end

      "unable to transition role from status #{current_status.inspect} to " \
        "#{status.inspect} - the role must be in status " \
        "#{format_valid_statuses}"
    end

    def format_valid_statuses
      tools.array_tools.humanize_list(
        valid_statuses.map(&:inspect),
        last_separator: ', or '
      )
    end
  end
end
