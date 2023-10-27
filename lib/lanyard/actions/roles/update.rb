# frozen_string_literal: true

module Lanyard::Actions::Roles
  # Update action for Role controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Lanyard::Actions::Roles::Concerns::GenerateSlug
  end
end
