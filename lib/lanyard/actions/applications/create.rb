# frozen_string_literal: true

module Lanyard::Actions::Applications
  # Create action for Application controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::Applications::Concerns::GenerateSlug
  end
end
