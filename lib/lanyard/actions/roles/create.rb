# frozen_string_literal: true

module Lanyard::Actions::Roles
  # Create action for Role controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::Roles::Concerns::GenerateSlug
  end
end
