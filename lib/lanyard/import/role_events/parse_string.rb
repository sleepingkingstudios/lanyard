# frozen_string_literal: true

module Lanyard::Import::RoleEvents
  # Parses a shorthand event string
  class ParseString < Cuprum::Command
    EVENT_TYPES = {
      'applied'   => RoleEvents::AppliedEvent,
      'closed'    => RoleEvents::ClosedEvent,
      'contacted' => RoleEvents::ContactedEvent,
      'pitched'   => RoleEvents::PitchedEvent,
      'rejected'  => RoleEvents::RejectedEvent,
      'submitted' => RoleEvents::PitchedEvent
    }.freeze
    private_constant :EVENT_TYPES

    MONTHS = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze
    private_constant :MONTHS

    private

    attr_reader :raw_value

    def parse_date(raw_month, raw_day)
      month = step { parse_month(raw_month) }
      day   = step { validate_day(raw_day) }
      year  = month > 6 ? 2023 : 2024

      Date.new(year, month, day)
    rescue Date::Error
      error = parse_error("invalid date #{year}, #{month}, #{day}")
      failure(error)
    end

    def parse_error(message)
      Lanyard::Import::Errors::ParseError.new(
        entity_class: RoleEvent,
        raw_value:    raw_value,
        message:      message
      )
    end

    def parse_month(raw_month)
      index = MONTHS.index(raw_month.downcase)

      return 1 + index if index

      error = parse_error("invalid month #{raw_month.inspect}")
      failure(error)
    end

    def parse_type(raw_type)
      event_class = EVENT_TYPES[raw_type.downcase]

      return event_class if event_class

      error = parse_error("invalid event type #{raw_type.inspect}")
      failure(error)
    end

    def process(raw_value)
      @raw_value = raw_value

      raw_type, raw_month, raw_day = step { split(raw_value) }

      event_class = step { parse_type(raw_type) }
      event_date  = step { parse_date(raw_month, raw_day) }

      {
        'event_date' => event_date,
        'type'       => event_class.name
      }
    end

    def split(raw_value)
      segments = raw_value.strip.split

      return success(segments) if segments.size == 3

      error = parse_error('wrong number of words')
      failure(error)
    end

    def validate_day(raw_day)
      day = raw_day.to_i

      return day if (1..31).cover?(day)

      error = parse_error("invalid day #{raw_day.inspect}")
      failure(error)
    end
  end
end
