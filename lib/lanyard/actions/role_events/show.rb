# frozen_string_literal: true

module Lanyard::Actions::RoleEvents
  # Show action for RoleEvent controllers.
  class Show < Cuprum::Rails::Actions::Show
    prepend Lanyard::Actions::RoleEvents::Concerns::FindBySlug
  end
end
