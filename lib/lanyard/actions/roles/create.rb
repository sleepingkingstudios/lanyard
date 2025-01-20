# frozen_string_literal: true

module Lanyard::Actions::Roles
  # Create action for Role controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::Roles::Concerns::GenerateSlug

    def create_entity(attributes:)
      attributes = attributes.merge({ 'last_event_at' => Time.current })

      super
    end
  end
end
