# frozen_string_literal: true

require 'cuprum/rails/errors/missing_parameter'

module Lanyard::Actions::RoleEvents::Concerns
  # Action helper for finding a role event by slug for a given role.
  module FindBySlug
    UUID_PATTERN = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
    private_constant :UUID_PATTERN

    private

    def destroy_entity(primary_key:)
      entity = step { find_entity(primary_key: primary_key) }

      collection.destroy_one.call(primary_key: entity.id)
    end

    def find_entity(primary_key:)
      role = step { find_role }

      if primary_key.match?(UUID_PATTERN)
        find_entity_by_id(role_id: role.id, id: primary_key)
      else
        find_entity_by_slug(role_id: role.id, slug: primary_key)
      end
    end

    def find_entity_by_id(id:, role_id:)
      result = collection.find_matching.call do
        {
          'id'      => id,
          'role_id' => role_id
        }
      end

      return success(result.value.first) if result.value.size.nonzero?

      failure(not_found_error(primary_key: true, value: id))
    end

    def find_entity_by_slug(role_id:, slug:)
      result = collection.find_matching.call do
        {
          'slug'    => slug,
          'role_id' => role_id
        }
      end

      return success(result.value.first) if result.value.size.nonzero?

      failure(not_found_error(primary_key: false, value: slug))
    end

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

    def not_found_error(primary_key:, value:)
      Cuprum::Collections::Errors::NotFound.new(
        attribute_name:  primary_key ? 'id' : 'slug',
        attribute_value: value,
        collection_name: resource.name,
        primary_key:     primary_key
      )
    end

    def roles_collection
      repository.find_or_create(
        entity_class:   Role,
        qualified_name: 'roles'
      )
    end
  end
end
