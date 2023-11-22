# frozen_string_literal: true

module Lanyard::Models::RoleEvents
  # Command listing the valid event types for a role.
  class ListEventTypes < Cuprum::Command
    class << self
      # @return [Hash{String=>Class}] the non-abstract event classes by
      #   human-readable type string.
      def all_event_types
        @all_event_types ||=
          event_types_for(RoleEvent)
          .except('Role')
          .sort
          .to_h
          .then { |hsh| { 'Event' => RoleEvent }.merge(hsh) }
      end

      private

      def event_types_for(event_class)
        hsh = {}

        unless event_class.abstract_event?
          name = RoleEvent.name_for(event_class.name)

          hsh[name] = event_class
        end

        event_class.subclasses.reduce(hsh) do |types, subclass|
          types.merge(event_types_for(subclass))
        end
      end
    end

    private

    def event_types
      self.class.all_event_types
    end

    def process(role)
      event_types
        .select { |_, event_class| event_class.valid_for?(role) }
        .map { |label, event_class| [label, type_for(event_class)] }
    end

    def type_for(event_class)
      return '' if event_class == RoleEvent

      event_class.name
    end
  end
end
