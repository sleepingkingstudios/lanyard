# frozen_string_literal: true

# Represents an interval searching for a new role.
class JobSearch < ApplicationRecord
  ### Associations
  has_many :applications, dependent: :nullify

  ### Validations
  validates :slug,
    format:     {
      message: I18n.t('errors.messages.kebab_case'),
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validates :start_date,
    presence:   true,
    uniqueness: true
  validate :end_date_at_end_of_month
  validate :start_date_at_start_of_month

  private

  def end_date_at_end_of_month
    return if end_date.nil?

    return if end_date == end_date.end_of_month

    errors.add(
      :end_date,
      I18n.t('lanyard.errors.models.job_searches.invalid_end_date')
    )
  end

  def start_date_at_start_of_month
    return if start_date.nil?

    return if start_date == start_date.beginning_of_month

    errors.add(
      :start_date,
      I18n.t('lanyard.errors.models.job_searches.invalid_start_date')
    )
  end
end

# == Schema Information
#
# Table name: job_searches
#
#  id         :uuid             not null, primary key
#  end_date   :date
#  slug       :string           default(""), not null
#  start_date :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_searches_on_slug        (slug) UNIQUE
#  index_job_searches_on_start_date  (start_date) UNIQUE
#
