# frozen_string_literal: true

require 'cuprum'

module Lanyard::Models::Cycles
  # Generates the name for a search Cycle.
  class GenerateName < Cuprum::Command
    private

    def process(attributes:)
      year = attributes['year']

      return '' if year.blank?

      season = season_for(attributes)

      return '' if season.blank?

      "#{season.titleize} #{year}"
    end

    def season_for(attributes)
      attributes.fetch('season') do
        index = attributes['season_index']

        next if index.nil?

        Cycle::Seasons.keys[index.to_i].to_s
      end
    end
  end
end
