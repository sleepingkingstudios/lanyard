# frozen_string_literal: true

module Lanyard::View::Components::Roles
  # Renders a single Role record.
  class Block < ViewComponent::Base # rubocop:disable Metrics/ClassLength
    COMPENSATION_FIELDS = [
      {
        key:   'compensation_type',
        label: 'Compensation',
        value: lambda { |item|
          value = item.compensation_type.titleize

          if item.compensation.present?
            value = "#{value} - #{item.compensation}"
          end

          value
        }
      }.freeze,
      {
        key:   'benefits',
        label: 'Benefits',
        value: lambda { |item|
          next 'No' unless item.benefits?

          value = 'Yes'

          if item.benefits_details.present?
            value = "#{value} - #{item.benefits_details}"
          end

          value
        }
      }
    ].freeze

    CORE_FIELDS = [
      { key: 'job_title' }.freeze,
      { key: 'company_name' }.freeze,
      {
        key:     'client_name',
        default: '(none)'
      }.freeze,
      { key: 'slug' }.freeze,
      {
        key:   'cycle',
        value: lambda { |item|
          return '(None)' if item.cycle.blank?

          Librum::Core::View::Components::Link.new(
            "/cycles/#{item.cycle.slug}",
            label: item.cycle.name
          )
        }
      }.freeze,
      {
        key:       'status',
        # :nocov:
        color:     lambda { |item|
          case item.status
          when Role::Statuses::NEW
            'info'
          when Role::Statuses::OPEN
            'success'
          when Role::Statuses::CLOSED
            'danger'
          end
        },
        # :nocov:
        transform: :titleize
      }.freeze,
      {
        key:   'contract_type',
        label: 'Contract',
        value: lambda { |item|
          value = item.contract_type.titleize

          if item.contract_duration.present?
            value = "#{value} - #{item.contract_duration}"
          end

          value
        }
      }.freeze,
      {
        key:   'location_type',
        label: 'Location',
        value: lambda { |item|
          value = item.location_type.titleize
          value = "#{value} - #{item.location}" if item.location.present?
          value = "#{value} (#{item.time_zone})" if item.time_zone.present?

          value
        }
      }.freeze,
      {
        key:     'industry',
        default: 'Unknown'
      }.freeze
    ].freeze
    private_constant :CORE_FIELDS

    RECRUITER_FIELDS = [
      {
        key:     'recruiter_name',
        default: '(none)'
      }.freeze,
      {
        key:     'agency_name',
        default: '(none)'
      }.freeze
    ].freeze
    private_constant :RECRUITER_FIELDS

    SOURCE_FIELDS = [
      {
        key:       'source',
        transform: :titleize
      }.freeze,
      { key: 'source_details' }
    ].freeze
    private_constant :SOURCE_FIELDS

    # @param data [Role] the role to display.
    def initialize(data:, **)
      super()

      @data = data
    end

    # @return [Role] the role to display.
    attr_reader :data

    private

    def compensation_fields
      COMPENSATION_FIELDS
    end

    def core_fields
      CORE_FIELDS
    end

    def recruiter_fields
      RECRUITER_FIELDS
    end

    def source_fields
      SOURCE_FIELDS
    end
  end
end
