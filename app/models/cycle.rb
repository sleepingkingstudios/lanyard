# frozen_string_literal: true

# Model class representing a job search period.
class Cycle < ApplicationRecord
  # Enumerates seasons for a job search cycle.
  Seasons = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    WINTER: 0,
    SPRING: 1,
    SUMMER: 2,
    AUTUMN: 3
  ).freeze

  INVERSE_SEASONS = Seasons.keys.map { |key| key.to_s.downcase }.freeze
  private_constant :INVERSE_SEASONS

  # Validations
  validates :name,
    presence:   true,
    uniqueness: true
  validates :slug,
    format:     {
      message: I18n.t('errors.messages.kebab_case'),
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validates :season, presence: true
  validates :year,
    format:   {
      with: /\A\d{4}\z/
    },
    presence: true

  # @return [String] the cycle season.
  def season
    return if season_index.nil?

    INVERSE_SEASONS[season_index]
  end

  # @param value [String] the cycle season.
  def season=(value)
    self.season_index = INVERSE_SEASONS.index(value)
  end
end

# == Schema Information
#
# Table name: cycles
#
#  id           :uuid             not null, primary key
#  name         :string           default(""), not null
#  season_index :integer          not null
#  slug         :string           default(""), not null
#  year         :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_cycles_on_name                   (name) UNIQUE
#  index_cycles_on_slug                   (slug) UNIQUE
#  index_cycles_on_year_and_season_index  (year,season_index) UNIQUE
#
