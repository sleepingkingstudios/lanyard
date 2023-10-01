# frozen_string_literal: true

FactoryBot.define do
  factory :cycle, class: 'Cycle' do
    transient do
      sequence(:cycle_index) { |index| 8400 + index }

      season do
        Cycle::Seasons.keys[cycle_index % 4].to_s.downcase
      end
    end

    season_index do
      Cycle::Seasons.keys.map { |key| key.to_s.downcase }.index(season)
    end
    year { cycle_index / 4 }
    name { "#{season.titleize} #{year}" }
    slug { "#{season}-#{year}" }
  end
end
