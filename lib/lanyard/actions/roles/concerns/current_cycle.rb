# frozen_string_literal: true

module Lanyard::Actions::Roles::Concerns
  # Helpers for referencing the most recent search cycle.
  module CurrentCycle
    private

    def current_cycle_id
      find_current_cycle.id
    end

    def current_cycle_scope
      Cuprum::Collections::Scope.new({ 'cycle_id' => current_cycle_id })
    end

    def cycles_collection
      repository.find_or_create(entity_class: Cycle)
    end

    def find_current_cycle
      order = {
        year:         :desc,
        season_index: :desc
      }
      values = step do
        cycles_collection
          .find_matching
          .call(limit: 1, order: order)
      end

      values.first
    end
  end
end
