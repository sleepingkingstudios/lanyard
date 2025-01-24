# frozen_string_literal: true

module Lanyard::View::Roles
  # Renders a form for a Role record.
  class Form < Librum::Core::View::Components::Resources::Form
    private

    def default_data
      {
        'cycles' => [],
        'role'   => Role.new
      }
    end

    def render_compensation_buttons
      items =
        Role::CompensationTypes
        .values
        .map { |value| { value: value } }

      render_form_radio_button_group('role[compensation_type]', items: items)
    end

    def render_contract_buttons
      items =
        Role::ContractTypes
        .values
        .map { |value| { value: value } }

      render_form_radio_button_group('role[contract_type]', items: items)
    end

    def render_cycle_field # rubocop:disable Metrics/MethodLength
      cycles =
        data
        .fetch('cycles', [])
        .sort { |u, v| v.created_at <=> u.created_at }
        .map { |cycle| { label: cycle.name, value: cycle.id } }

      render_form_field(
        'role[cycle_id]',
        error_key: 'role[cycle]',
        label:     'Cycle',
        type:      :select,
        items:     cycles
      )
    end

    def render_location_buttons
      items =
        Role::LocationTypes
        .values
        .map { |value| { value: value } }

      render_form_radio_button_group('role[location_type]', items: items)
    end

    def render_source_field
      sources =
        Role::Sources
        .map { |key, value| { label: key.to_s.titleize, value: value } }

      render_form_field(
        'role[source]',
        label: 'Source',
        type:  :select,
        items: sources
      )
    end
  end
end
