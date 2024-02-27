# frozen_string_literal: true

module Lanyard::Actions::Roles
  # Action for querying active roles in the current cycle.
  class Active < Cuprum::Rails::Actions::Index
    include Lanyard::Actions::Roles::Concerns::CurrentCycle

    SCOPE =
      Cuprum::Collections::Scope
      .new { { 'status' => not_equal(Role::Statuses::CLOSED) } }
      .freeze
    private_constant :SCOPE

    private

    def find_entities(limit:, offset:, order:, &block)
      scoped =
        collection
        .with_scope(SCOPE)
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
