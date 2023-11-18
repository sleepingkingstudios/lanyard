# frozen_string_literal: true

# Model class representing an event in a role application process.
class RoleEvent < ApplicationRecord
  extend Librum::Core::Models::DataProperties

  class << self
    # @return [Boolean] true if the event class is abstract, and should not
    #   allow persisting events of this type.
    def abstract_event?
      false
    end

    # @return [Hash{String=>String}] a mapping of the valid (non-abstract) event
    #   subclass types and the corresponding huamn-readable type.
    def event_types
      @event_types ||= generate_event_types
    end

    # Generates the event name for a given type.
    #
    # @param type [String] the event type.
    #
    # @return [String] a human-readable event type.
    def name_for(type)
      return 'Event' if type.blank?

      type.split('::').last.sub(/Event\z/, '')
    end

    private

    def event_types_for(klass)
      hsh = klass.abstract_event? ? {} : { name_for(klass.name) => klass.name }

      klass.subclasses.reduce(hsh) do |types, subclass|
        types.merge(event_types_for(subclass))
      end
    end

    def generate_event_types
      event_types_for(RoleEvent)
        .except('Role')
        .sort
        .unshift(['Event', ''])
        .to_h
    end
  end

  ### Attributes
  data_property :summary

  ### Associations
  belongs_to :role

  ### Validations
  validates :event_date,
    presence: true
  validates :event_index,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer:             true,
      unless:                   ->(event) { event.event_index.nil? }
    },
    presence:     true
  validates :slug,
    format:     {
      message: ->(*) { I18n.t('errors.messages.kebab_case') },
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validate :event_class_is_not_abstract
  validate :event_is_last_event,   on: :create
  validate :event_date_unchanged,  on: :update
  validate :event_index_unchanged, on: :update
  validate :event_type_unchanged,  on: :update

  # @return [String] the default summary for the event type.
  def default_summary
    'Generic role event'
  end

  # @return [String] a human-readable event type.
  def name
    self.class.name_for(type)
  end

  # @return [String] a brief text description for the event.
  def summary
    data['summary'].presence || default_summary
  end

  private

  def event_class_is_not_abstract
    return unless self.class.abstract_event?

    errors.add(
      :type,
      I18n.t('lanyard.errors.models.role_events.is_abstract')
    )
  end

  def event_date_unchanged
    return unless event_date_changed?

    errors.add(
      :event_date,
      I18n.t('lanyard.errors.models.role_events.is_static')
    )
  end

  def event_index_unchanged
    return unless event_index_changed?

    errors.add(
      :event_index,
      I18n.t('lanyard.errors.models.role_events.is_static')
    )
  end

  def event_is_last_event
    return unless event_date.is_a?(Date)

    return unless role

    last_event = role.events.order({ event_date: :desc }).first

    return if last_event.blank?

    return if last_event.event_date <= event_date

    errors.add(
      :event_date,
      I18n.t('lanyard.errors.models.role_events.is_not_last_event')
    )
  end

  def event_type_unchanged
    return unless type_changed?

    errors.add(
      :event_type,
      I18n.t('lanyard.errors.models.role_events.is_static')
    )
  end
end

# == Schema Information
#
# Table name: role_events
#
#  id          :uuid             not null, primary key
#  data        :jsonb            not null
#  event_date  :date             not null
#  event_index :integer          not null
#  notes       :text             default(""), not null
#  slug        :string           default(""), not null
#  type        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role_id     :uuid
#
# Indexes
#
#  index_role_events_on_role_id_and_event_index  (role_id,event_index) UNIQUE
#  index_role_events_on_role_id_and_slug         (role_id,slug) UNIQUE
#  index_role_events_on_slug                     (slug) UNIQUE
#
