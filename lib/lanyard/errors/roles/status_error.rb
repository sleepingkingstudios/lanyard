# frozen_string_literal: true

module Lanyard::Errors::Roles
  # Abstract error returned for an invalid role or event status.
  class StatusError < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'lanyard.errors.roles.status_error'

    # @param message [String] the message to display.
    # @param status [String] the invalid status.
    def initialize(status:, message: nil)
      super(message: message)

      @status = status
    end

    # @return status [String] the invalid status.
    attr_reader :status

    private

    def as_json_data
      { 'status' => status }
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
