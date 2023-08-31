# frozen_string_literal: true

module Lanyard::Actions::JobSearches
  # Update action for JobSearch controllers.
  class Update < Cuprum::Rails::Actions::Update
    prepend Librum::Core::Actions::FindBySlug
    prepend Lanyard::Actions::JobSearches::Concerns::GenerateSlug
    prepend Lanyard::Actions::JobSearches::Concerns::NormalizeDates
  end
end
