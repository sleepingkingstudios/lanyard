# frozen_string_literal: true

require 'cuprum/rails/transaction'

module Lanyard::Import::Roles
  # Creates a role and associated events from serialized data.
  class ImportRole < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   Cycle, Role, and RoleEvent entities.
    # @param [Integer] the year for implicit date resolution.
    def initialize(repository:, year: nil)
      super()

      @repository = repository
      @year       = year || Time.current.year
    end

    # @return [Cuprum::Collections::Repository] the repository for Cycle, Role,
    #   and RoleEvent entities.
    attr_reader :repository

    # @return [Integer] the year for implicit event date resolution.
    attr_reader :year

    private

    def create_events(attributes:, role:)
      Lanyard::Import::Roles::ImportEvents
        .new(repository: repository, year: year)
        .call(events: attributes.fetch('events', []), role: role)
    end

    def create_role(attributes:)
      attributes = step { parse_attributes(attributes: attributes) }
      role       = step do
        roles_collection.build_one.call(attributes: attributes)
      end

      step { roles_collection.validate_one.call(entity: role) }

      step { roles_collection.insert_one.call(entity: role) }
    end

    def current_cycle_id # rubocop:disable Metrics/MethodLength
      result =
        cycles_collection
        .find_matching
        .call(limit: 1) { { active: true } }

      return result unless result.success?

      return success(result.value.first.id) unless result.value.size.zero? # rubocop:disable Style/ZeroLengthPredicate

      error = Cuprum::Collections::Errors::NotFound.new(
        attributes:      { 'active' => true },
        collection_name: 'cycles'
      )
      failure(error)
    end

    def cycles_collection
      repository.find_or_create(entity_class: Cycle)
    end

    def first_event_at(attributes:)
      return unless attributes.key?('events') && attributes['events'].present?

      result =
        Lanyard::Import::RoleEvents::ParseString
        .new(year: year)
        .call(attributes['events'].first)

      return unless result.success?

      success(result.value['event_date'])
    end

    def generate_slug(attributes:)
      created_at = step { first_event_at(attributes: attributes) }
      attributes = attributes.merge('created_at' => created_at) if created_at

      Lanyard::Models::Roles::GenerateSlug
        .new(repository: repository)
        .call(attributes: attributes)
    end

    def parse_attributes(attributes:) # rubocop:disable Metrics/MethodLength
      attributes = attributes.except('events').merge(
        'cycle_id'      => step { current_cycle_id },
        'last_event_at' => Time.current,
        'slug'          => step { generate_slug(attributes: attributes) }
      )

      [
        Lanyard::Import::Roles::ParseCompensation.new,
        Lanyard::Import::Roles::ParseNotes.new,
        Lanyard::Import::Roles::ParseSource.new
      ].reduce(attributes) do |hsh, command|
        step { command.call(attributes: hsh) }
      end
    end

    def process(attributes:)
      transaction do
        role = step { create_role(attributes: attributes) }

        step { create_events(attributes: attributes, role: role) }

        role.reload
      end
    end

    def roles_collection
      repository.find_or_create(entity_class: Role)
    end

    def transaction(&block)
      Cuprum::Rails::Transaction.new.call(&block)
    end
  end
end
