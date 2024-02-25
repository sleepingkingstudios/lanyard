# frozen_string_literal: true

module Lanyard::Models::RoleEvents
  # Validates that a role is valid for creating an event.
  class ValidateRole < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role and RoleEvent entities.
    def initialize(repository:)
      super()

      @repository = repository
    end

    # @return [Cuprum::Collections::Repository] the repository for Role
    #   entities.
    attr_reader :repository

    private

    def process(role:) # rubocop:disable Lint/UnusedMethodArgument
      success(nil)
    end
  end
end
