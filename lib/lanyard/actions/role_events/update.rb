# frozen_string_literal: true

module Lanyard::Actions::RoleEvents
  # Update action for RoleEvent controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Lanyard::Actions::RoleEvents::Concerns::FindBySlug
    prepend Lanyard::Actions::RoleEvents::Concerns::GenerateSlug
  end
end
