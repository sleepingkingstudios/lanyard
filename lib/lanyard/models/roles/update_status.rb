# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's status and corresponding timestamp.
  class UpdateStatus < Lanyard::Models::Roles::UpdateLastEvent
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role entities.
    # @param status [String] the status to assign to the role.
    def initialize(repository:, status:)
      super(repository: repository)

      @status = status
    end

    # @return [String] the status to assign to the role.
    attr_reader :status

    private

    def attributes_for(role:)
      super.merge(
        status:           status,
        timestamp_name => Time.current
      )
    end

    def process(role:)
      step { validate_status }

      super
    end

    def timestamp_name
      :"#{status}_at"
    end

    def validate_status
      return if Role::Statuses.values.include?(status)

      error = Lanyard::Errors::Roles::InvalidStatus.new(status: status)
      failure(error)
    end
  end
end
