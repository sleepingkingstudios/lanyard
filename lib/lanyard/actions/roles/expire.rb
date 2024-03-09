# frozen_string_literal: true

require 'cuprum/rails/errors/missing_parameter'

module Lanyard::Actions::Roles
  # Adds a new expired event to the role.
  class Expire < Cuprum::Rails::Action
    private

    def create_event(role:)
      Lanyard::Models::Roles::CreateEvent
        .new(repository: repository)
        .call(
          attributes: {
            'event_date' => (role.last_event_at + 2.weeks),
            'type'       => RoleEvents::ExpiredEvent.name
          },
          role:       role
        )
    end

    def process(request:, repository:, **)
      super

      role = step { require_role }

      create_event(role: role)
    end

    def require_role
      Librum::Core::Models::Queries::FindOne
        .new(collection: roles_collection)
        .call(value: step { role_id })
    end

    def role_id
      role_id = params.fetch('role_id', params['id'])

      return success(role_id) if role_id

      error = Cuprum::Rails::Errors::MissingParameter.new(
        parameter_name: 'role_id',
        parameters:     params
      )
      failure(error)
    end

    def roles_collection
      repository.find_or_create(entity_class: Role)
    end
  end
end
