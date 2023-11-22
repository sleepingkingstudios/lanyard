# frozen_string_literal: true

module Lanyard::Models::Roles
  # Updates a role's status and corresponding timestamp.
  class UpdateStatus < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role entities.
    # @param status [String] the status to assign to the role.
    def initialize(repository:, status:)
      super()

      @repository = repository
      @status     = status
    end

    # @return [Cuprum::Collections::Repository] the repository for Role
    #   entities.
    attr_reader :repository

    # @return [String] the status to assign to the role.
    attr_reader :status

    private

    def process(role:)
      step { validate_status }

      attributes = {
        status:           status,
        timestamp_name => Time.current
      }

      update_role(attributes: attributes, role: role)
    end

    def roles_collection
      @roles_collection ||= repository.find_or_create(entity_class: Role)
    end

    def timestamp_name
      :"#{status}_at"
    end

    def update_role(attributes:, role:)
      assigned = step do
        roles_collection.assign_one.call(attributes: attributes, entity: role)
      end

      step { roles_collection.validate_one.call(entity: assigned) }

      step { roles_collection.update_one.call(entity: assigned) }
    end

    def validate_status
      return if Role::Statuses.values.include?(status)

      error = Lanyard::Errors::Roles::InvalidStatus.new(status: status)
      failure(error)
    end
  end
end
