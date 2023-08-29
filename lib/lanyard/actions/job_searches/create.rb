# frozen_string_literal: true

module Lanyard::Actions::JobSearches
  # Create action for JobSearch controllers.
  class Create < Cuprum::Rails::Actions::Create
    prepend Lanyard::Actions::JobSearches::Concerns::GenerateSlug
    prepend Lanyard::Actions::JobSearches::Concerns::NormalizeDates
  end
end
