# frozen_string_literal: true

module Lanyard::View::Cycles
  # Renders a form for a Cycle record.
  class Form < Librum::Core::View::Components::Resources::Form
    private

    def build_name_input
      Librum::Core::View::Components::FormInput.new(
        'name',
        type:  'hidden',
        value: ''
      )
    end

    def build_slug_input
      Librum::Core::View::Components::FormInput.new(
        'slug',
        type:  'hidden',
        value: ''
      )
    end

    def default_data
      { 'cycle' => ::Cycle.new }
    end

    def render_name_input
      render(build_name_input)
    end

    def render_slug_input
      render(build_slug_input)
    end
  end
end
