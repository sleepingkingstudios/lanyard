# frozen_string_literal: true

module Lanyard::View::RoleEvents
  # Renders a form for a RoleEvent record.
  class Form < Librum::Core::View::Components::Resources::Form
    private

    def render_event_field # rubocop:disable Metrics/MethodLength
      role        = data.fetch('role') { return nil }
      command     = Lanyard::Models::RoleEvents::ListEventTypes.new
      event_types = command.call(role).value.map do |type, event_class|
        { label: type, value: event_class }
      end

      render_form_field(
        'event[type]',
        type:     :select,
        items:    event_types,
        disabled: action == 'edit'
      )
    end

    def render_role_input
      role = data.fetch('role') { return nil }

      render(
        Librum::Core::View::Components::FormInput.new(
          'event[role_id]',
          value: role.id,
          type:  :hidden
        )
      )
    end
  end
end
