# frozen_string_literal: true

module Lanyard::Actions::Cycles::Concerns
  # Action helper for generating a name for a search cycle.
  module GenerateName
    private

    def create_entity(attributes:)
      attributes = attributes.merge({
        'name' => step { generate_name(attributes) }
      })

      super
    end

    def generate_name(attributes)
      return success(attributes['name']) if attributes['name'].present?

      Lanyard::Models::Cycles::GenerateName.new.call(attributes: attributes)
    end

    def update_entity(attributes:)
      if attributes.key?('name')
        attributes = attributes.merge({
          'name' => step { generate_name(attributes) }
        })
      end

      super
    end
  end
end
