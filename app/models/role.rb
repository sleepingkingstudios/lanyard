# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Model class representing an application process for a role.
class Role < ApplicationRecord
  extend Librum::Core::Models::DataProperties

  # Enumerates types of compensation for a role.
  CompensationTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    HOURLY:   'hourly',
    SALARIED: 'salaried',
    UNKNOWN:  'unknown'
  ).freeze

  # Enumerates role contract types.
  ContractTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    CONTRACT:         'contract',
    CONTRACT_TO_HIRE: 'contract_to_hire',
    FULL_TIME:        'full_time',
    UNKNOWN:          'unknown'
  ).freeze

  # Enumerates role location types.
  LocationTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    HYBRID:    'hybrid',
    IN_PERSON: 'in_person',
    REMOTE:    'remote',
    UNKNOWN:   'unknown'
  ).freeze

  # Enumerates role sources.
  Sources = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    EMAIL:    'email',
    HIRED:    'hired',
    LINKEDIN: 'linkedin',
    OTHER:    'other',
    REFERRAL: 'referral',
    UNKNOWN:  'unknown'
  ).freeze

  # Enumerates role statuses.
  Statuses = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    CLOSED: 'closed',
    NEW:    'new',
    OPEN:   'open'
  ).freeze

  ### Attributes
  data_property :benefits, predicate: true
  data_property :benefits_details
  data_property :compensation
  data_property :contract_duration
  data_property :industry
  data_property :location
  data_property :source_details
  data_property :time_zone

  ### Associations
  belongs_to :cycle

  ### Validations
  validates :compensation_type,
    inclusion: {
      allow_nil: true,
      in:        CompensationTypes.values
    },
    presence:  true
  validates :contract_type,
    inclusion: {
      allow_nil: true,
      in:        ContractTypes.values
    },
    presence:  true
  validates :location_type,
    inclusion: {
      allow_nil: true,
      in:        LocationTypes.values
    },
    presence:  true
  validates :slug,
    format:     {
      message: I18n.t('errors.messages.kebab_case'),
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validates :source,
    inclusion: {
      allow_nil: true,
      in:        Sources.values
    },
    presence:  true
  validates :status,
    inclusion: {
      allow_nil: true,
      in:        Statuses.values
    },
    presence:  true

  # @return [Boolean] true if the applied role is for an agency client;
  #   otherwise false.
  def client?
    client_name.present?
  end

  # @return [Boolean] true if the role is a contract role; otherwise false.
  def contract?
    contract_type == ContractTypes::CONTRACT ||
      contract_type == ContractTypes::CONTRACT_TO_HIRE
  end

  # @return [Boolean] true if the role is a full-time role; otherwise false.
  def full_time?
    contract_type == ContractTypes::FULL_TIME
  end

  # @return [Boolean] true if the role is paid hourly; otherwise false.
  def hourly?
    compensation_type == CompensationTypes::HOURLY
  end

  # @return [Boolean] true if the role requires in-person attendance; otherwise
  #   false.
  def in_person?
    location_type == LocationTypes::HYBRID ||
      location_type == LocationTypes::IN_PERSON
  end

  # @return [Boolean] true if the role is fully remote; otherwise false.
  def remote?
    location_type == LocationTypes::REMOTE
  end

  # @return [Boolean] true if the role is salaried; otherwise false.
  def salaried?
    compensation_type == CompensationTypes::SALARIED
  end
end

# == Schema Information
#
# Table name: roles
#
#  id                :uuid             not null, primary key
#  agency_name       :string           default(""), not null
#  client_name       :string           default(""), not null
#  closed_at         :datetime
#  company_name      :string           default(""), not null
#  compensation_type :string           default("unknown"), not null
#  contract_type     :string           default("unknown"), not null
#  data              :jsonb            not null
#  job_title         :string           default(""), not null
#  location_type     :string           default("unknown"), not null
#  notes             :text             default(""), not null
#  opened_at         :datetime
#  recruiter_name    :string           default(""), not null
#  slug              :string           default(""), not null
#  source            :string           default("unknown"), not null
#  status            :string           default("new"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cycle_id          :uuid
#
# Indexes
#
#  index_roles_on_cycle_id_and_slug  (cycle_id,slug) UNIQUE
#  index_roles_on_slug               (slug) UNIQUE
#
