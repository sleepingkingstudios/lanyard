# frozen_string_literal: true

module Lanyard::Models::Roles
  # Generates a slug for a Role model.
  class GenerateSlug < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Role entities.
    def initialize(repository:)
      super()

      @repository = repository
    end

    # @return [Cuprum::Collections::Repository] the repository for Role
    #   entities.
    attr_reader :repository

    private

    def company_or_agency(attributes)
      if attributes['company_name'].present?
        attributes['company_name']
      elsif attributes['agency_name'].present?
        "agency #{attributes['agency_name']}"
      elsif attributes['recruiter_name'].present?
        "recruiter #{attributes['recruiter_name']}"
      end
    end

    def format_value(value)
      return if value.blank?

      I18n
        .transliterate(value)
        .underscore
        .gsub(/[^a-z0-9]+/, '-')
        .sub(/\A-+/, '')
        .sub(/-+\z/, '')
    end

    def generate_slug_for(attributes)
      segments = [
        generate_timestamp,
        format_value(company_or_agency(attributes)),
        format_value(attributes['job_title'])
      ].compact

      segments << role_index if segments.size == 1

      segments.join('-')
    end

    def generate_timestamp
      Time.current.strftime('%Y-%m-%d')
    end

    def process(attributes:)
      super()

      validate_attributes!(attributes)

      generate_slug_for(attributes.stringify_keys)
    end

    def role_index
      roles_collection
        .query
        .where { { created_at: gte(Time.current.beginning_of_day) } }
        .count
    end

    def roles_collection
      @roles_collection ||= repository.find_or_create(entity_class: Role)
    end

    def validate_attributes!(attributes)
      return if attributes.is_a?(Hash)

      raise ArgumentError, 'attributes must be a Hash'
    end
  end
end
