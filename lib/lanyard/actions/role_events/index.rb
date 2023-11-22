# frozen_string_literal: true

module Lanyard::Actions::RoleEvents
  # Index action for RoleEvent controllers.
  class Index < Librum::Core::Actions::Index
    UUID_PATTERN = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
    private_constant :UUID_PATTERN

    private

    def find_role
      primary_key = request.parameters.fetch('role_id') do
        return failure(missing_role_id_error)
      end

      if primary_key.match?(UUID_PATTERN)
        roles_collection.find_one.call(primary_key: primary_key)
      else
        Librum::Core::Models::Queries::FindBySlug
          .new(collection: roles_collection)
          .call(slug: primary_key)
      end
    end

    def missing_role_id_error
      Cuprum::Rails::Errors::MissingParameter.new(
        parameter_name: 'role_id',
        parameters:     request.parameters
      )
    end

    def roles_collection
      repository.find_or_create(
        entity_class:   Role,
        qualified_name: 'roles'
      )
    end

    def where
      role = step { find_role }

      { 'role_id' => role.id }
    end
  end
end
