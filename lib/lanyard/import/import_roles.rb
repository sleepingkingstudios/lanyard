# frozen_string_literal: true

require 'cuprum/map_command'

module Lanyard::Import
  # Parses and imports serialized roles.
  class ImportRoles < Cuprum::Command
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

    def map_command
      command =
        Lanyard::Import::Roles::ImportRole
        .new(repository: repository, year: year)

      Cuprum::MapCommand
        .new { |attributes| command.call(attributes: attributes) }
    end

    def parse_data(raw_data)
      YAML.safe_load(raw_data)
    rescue Psych::SyntaxError => exception
      error = Lanyard::Import::Errors::ParseError.new(
        message:   exception.message,
        raw_value: raw_data
      )
      failure(error)
    end

    def process(raw_data:)
      yaml_data = step { parse_data(raw_data) }

      map_command.call((yaml_data || []).each)
    end
  end
end
