# frozen_string_literal: true

module Lanyard::Actions::Roles::Concerns
  # Action helper for generating a slug for a role.
  module GenerateSlug
    private

    def create_entity(attributes:)
      attributes = attributes.merge({
        'slug' => step { generate_slug(attributes) }
      })

      super(attributes: attributes)
    end

    def generate_slug(attributes)
      return success(attributes['slug']) if attributes['slug'].present?

      Lanyard::Models::Roles::GenerateSlug
        .new(repository: repository)
        .call(attributes: attributes)
    end

    def update_entity(attributes:)
      if attributes.key?('slug')
        attributes = attributes.merge({
          'slug' => step { generate_slug(attributes) }
        })
      end

      super(attributes: attributes)
    end
  end
end
