# frozen_string_literal: true

# Model class representing an event in a role application process.
class RoleEvent < ApplicationRecord
  ### Associations
  belongs_to :role

  ### Validations
  validates :slug,
    format:     {
      message: I18n.t('errors.messages.kebab_case'),
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true

  # @return [Boolean] true if the event closes the associated role; otherwise
  #   false.
  def close_event?
    false
  end

  # @return [Boolean] true if the event opens the associated role; otherwise
  #   false.
  def open_event?
    false
  end
end

# == Schema Information
#
# Table name: role_events
#
#  id         :uuid             not null, primary key
#  data       :jsonb            not null
#  notes      :text             default(""), not null
#  slug       :string           default(""), not null
#  type       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :uuid
#
# Indexes
#
#  index_role_events_on_role_id_and_slug  (role_id,slug) UNIQUE
#  index_role_events_on_slug              (slug) UNIQUE
#