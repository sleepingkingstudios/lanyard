# frozen_string_literal: true

module Lanyard::Errors::Roles
  # Error returned for an invalid role status.
  class InvalidStatus < Lanyard::Errors::Roles::StatusError
    # Short string used to identify the type of error.
    TYPE = 'lanyard.errors.roles.invalid_status'

    # @param status [String] the invalid status.
    def initialize(status:)
      message = default_message_for(status: status)

      super(message: message, status: status)
    end

    # @return status [String] the invalid status.
    attr_reader :status

    private

    def default_message_for(status:)
      "invalid status #{status.inspect} - valid statuses are " \
        "#{format_valid_statuses}"
    end

    def format_valid_statuses
      tools.array_tools.humanize_list(valid_statuses.map(&:inspect))
    end

    def valid_statuses
      Role::Statuses.values
    end
  end
end
