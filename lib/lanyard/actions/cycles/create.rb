# frozen_string_literal: true

module Lanyard::Actions::Cycles
  # Create action for Cycle controllers.
  class Create < Librum::Core::Actions::Create
    prepend Lanyard::Actions::Cycles::Concerns::GenerateName
  end
end
