# frozen_string_literal: true

require 'cuprum/rails/transaction'

module Lanyard::Import::Roles
  # Creates lifecycle events from role attributes.
  class ImportEvents < Cuprum::Command
    # @param repository [Cuprum::Collections::Repository] the repository for
    #   RoleEvent entities.
    # @param [Integer] the year for implicit date resolution.
    def initialize(repository:, year: nil)
      super()

      @repository = repository
      @year       = year || Time.current.year
    end

    # @return repository [Cuprum::Collections::Repository] the repository for
    #   RoleEvent entities.
    attr_reader :repository

    # @return [Integer] the year for implicit date resolution.
    attr_reader :year

    private

    def create_event(attributes:, role:)
      @create_event ||=
        Lanyard::Models::Roles::CreateEvent.new(repository: repository)

      @create_event.call(attributes: attributes, role: role)
    end

    def create_expired_event(role:)
      return unless role.reload.expiring?

      attributes = {
        'event_date' => (role.last_event_at + 2.weeks),
        'type'       => RoleEvents::ExpiredEvent.name
      }
      create_event(attributes: attributes, role: role)
    end

    def parse_event(event)
      @parse_event ||= Lanyard::Import::RoleEvents::ParseString.new(year: year)

      @parse_event.call(event)
    end

    def process(events:, role:)
      transaction do
        events.each.with_index do |event, index|
          parsed     = step { parse_event(event) }
          attributes = parsed.merge('event_index' => index)

          step { create_event(attributes: attributes, role: role) }
        end

        create_expired_event(role: role)
      end
    end

    def transaction(&block)
      Cuprum::Rails::Transaction.new.call(&block)
    end
  end
end
