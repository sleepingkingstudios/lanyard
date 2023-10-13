# frozen_string_literal: true

module Lanyard::Actions::Cycles
  # Update action for Cycle controllers.
  class Update < Librum::Core::Actions::Update
    prepend Lanyard::Actions::Cycles::Concerns::GenerateName
  end
end
