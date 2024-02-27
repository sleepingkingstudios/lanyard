# frozen_string_literal: true

module Lanyard::Responders::Html
  # Delegates missing pages to View::Pages::Resources.
  class ResourceResponder < Librum::Core::Responders::Html::ResourceResponder
    private

    def view_component_name(action: nil)
      engine = extract_engine_name

      return super if engine.present?

      scope  = extract_scope(engine)
      action = (action || action_name).to_s.camelize

      "Lanyard::View::#{scope}::#{action}Page"
    end
  end
end
