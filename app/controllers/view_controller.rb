# frozen_string_literal: true

# Abstract base controller for rendering HTML responses.
class ViewController < Librum::Core::ViewController
  def self.navigation
    @navigation ||= {
      icon:  'briefcase',
      label: 'Home',
      items: [
        {
          label: 'Cycles',
          url:   '/cycles'
        }
      ]
    }
  end

  middleware Librum::Core::Actions::View::Middleware::PageNavigation.new(
    navigation: navigation
  )
end
