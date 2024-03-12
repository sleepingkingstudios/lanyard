# frozen_string_literal: true

module Lanyard::Import::Roles
  # Parses a compensation representation into role attributes.
  class ParseCompensation < Cuprum::Command
    private

    def process(attributes:) # rubocop:disable Metrics/MethodLength
      return attributes if attributes['compensation'].blank?

      compensation = attributes['compensation'].strip

      if compensation.include?('/hr') || compensation.include?('/hour')
        return attributes.merge(
          'compensation_type' => Role::CompensationTypes::HOURLY
        )
      end

      if compensation.include?('/yr') || compensation.include?('/year')
        return attributes.merge(
          'compensation_type' => Role::CompensationTypes::SALARIED
        )
      end

      attributes
    end
  end
end
