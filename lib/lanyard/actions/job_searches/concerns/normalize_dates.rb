# frozen_string_literal: true

module Lanyard::Actions::JobSearches::Concerns
  # Normalizes the start_date and end_date attribute.
  module NormalizeDates
    private

    def create_entity(attributes:)
      attributes = step { normalize_dates(attributes) }

      super(attributes: attributes)
    end

    def normalize_dates(attributes)
      Lanyard::Models::JobSearches::NormalizeDates
        .new
        .call(attributes: attributes)
    end

    def update_entity(attributes:)
      attributes = step { normalize_dates(attributes) }

      super(attributes: attributes)
    end
  end
end
