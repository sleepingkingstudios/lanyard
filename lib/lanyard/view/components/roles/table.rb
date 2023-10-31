# frozen_string_literal: true

module Lanyard::View::Components::Roles
  # Renders a table of Role records.
  class Table < Librum::Core::View::Components::Resources::Table
    COLUMNS = lambda { # rubocop:disable Metrics/BlockLength
      [
        {
          key:      'job_title',
          url:      ->(item) { "/roles/#{item.slug}" },
          value:    ->(item) { item.job_title.presence || '(unknown)' },
          truncate: 25,
          type:     :link
        },
        {
          key:      'company_name',
          label:    'Company',
          default:  '(unknown)',
          truncate: 25
        },
        {
          key:   'contract?',
          label: 'Contract',
          type:  :boolean
        },
        {
          key:   'remote?',
          label: 'Remote',
          type:  :boolean
        },
        {
          key:       'status',
          color:     lambda { |item|
            case item.status
            when Role::Statuses::NEW
              'black'
            when Role::Statuses::APPLIED
              'info'
            when Role::Statuses::INTERVIEWING, Role::Statuses::OFFERED
              'success'
            when Role::Statuses::CLOSED
              'danger'
            end
          },
          transform: :titleize
        },
        {
          key:   'cycle',
          value: lambda { |item|
            return '(None)' if item.cycle.blank?

            Librum::Core::View::Components::Link.new(
              "/cycles/#{item.cycle.slug}",
              label: item.cycle.name
            )
          }
        },
        {
          key:      'actions',
          label:    ' ',
          resource: resource,
          type:     :actions
        }
      ].freeze
    }.freeze
    private_constant :COLUMNS

    # @param data [Array<Role>] the table data to render.
    # @param resource [Cuprum::Rails::Resource] the controller resource.
    def initialize(data:, resource:)
      super(
        columns:  COLUMNS,
        data:     data,
        resource: resource
      )
    end

    attr_reader :resource
  end
end
