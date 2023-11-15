# frozen_string_literal: true

# Model class representing an event in a role application process.
class RoleEvent < ApplicationRecord
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

  ### Associations
  belongs_to :role

  ### Validations
  validates :event_date,
    presence: true
  validates :slug,
    format:     {
      message: ->(*) { I18n.t('errors.messages.kebab_case') },
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validate :event_class_is_not_abstract

  # @return [String] a human-readable event type.
  def name
    self.class.name_for(type)
  end

  private

  def event_class_is_not_abstract
    return unless self.class.abstract_event?

    errors.add(
      :type,
      I18n.t('lanyard.errors.models.role_events.is_abstract')
    )
  end
end

# == Schema Information
#
# Table name: role_events
#
#  id         :uuid             not null, primary key
#  data       :jsonb            not null
#  event_date :date             not null
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
