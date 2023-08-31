# frozen_string_literal: true

module Lanyard::Actions::Applications
  # Update action for Application controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Lanyard::Actions::Applications::Concerns::GenerateSlug
  end
end
