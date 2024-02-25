# frozen_string_literal: true

module Lanyard::Models::RoleEvents
  # Validates a status transition for a specified role.
  class ValidateStatusTransition < Lanyard::Models::RoleEvents::ValidateRole
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role and RoleEvent entities.
    # @param status [String] the status to transition to the role into.
    # @param valid_statuses [Array<String>] the valid statuses for the role
    #   transition.
    def initialize(repository:, status:, valid_statuses:)
      super(repository: repository)

      @status         = status
      @valid_statuses = Set.new(valid_statuses)
    end

    # @return [String] the status to transition to the role into.
    attr_reader :status

    # @return [Array<String>] the valid statuses for the role transition.
    attr_reader :valid_statuses

    private

    def process(role:)
      return if valid_statuses.include?(role.status)

      error = Lanyard::Errors::Roles::InvalidStatusTransition.new(
        current_status: role.status,
        status:         status,
        valid_statuses: valid_statuses.to_a
      )
      failure(error)
    end
  end
end
