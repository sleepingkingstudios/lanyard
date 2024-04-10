# frozen_string_literal: true

module Lanyard::Actions::Roles
  # Action for querying expiring roles in the current cycle.
  class Expiring < Cuprum::Rails::Actions::Index
    include Lanyard::Actions::Roles::Concerns::CurrentCycle

    private

    def find_entities(limit:, offset:, order:, &block)
      scoped =
        collection
        .with_scope(Role::EXPIRING.call)
        .with_scope(current_cycle_scope)

      scoped.find_matching.call(
        limit:  limit,
        offset: offset,
        order:  order,
        &block
      )
    end
  end
end
