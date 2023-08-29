# frozen_string_literal: true

# Abstract base controller for rendering HTML pages.
class ViewController < Librum::Core::ViewController
  def self.navigation
    @navigation ||= {
      icon:  'briefcase',
      label: 'Home',
      items: [
        {
          label: 'Job Searches',
          url:   '/job-searches'
        }
      ]
    }
  end

  middleware Librum::Core::Actions::View::Middleware::PageNavigation.new(
    navigation: navigation
  )
end
