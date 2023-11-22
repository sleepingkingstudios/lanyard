# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/log_request'
require 'cuprum/rails/actions/middleware/log_result'

# Abstract base controller for rendering HTML responses.
class ViewController < Librum::Core::ViewController
  def self.navigation # rubocop:disable Metrics/MethodLength
    @navigation ||= {
      icon:  'briefcase',
      label: 'Home',
      items: [
        {
          label: 'Roles',
          url:   '/roles'
        },
        {
          label: 'Cycles',
          url:   '/cycles'
        }
      ]
    }
  end

  # :nocov:
  if Rails.env.development?
    middleware Cuprum::Rails::Actions::Middleware::LogRequest

    middleware Cuprum::Rails::Actions::Middleware::LogResult
  end
  # :nocov:

  middleware Librum::Core::Actions::View::Middleware::PageNavigation.new(
    navigation: navigation
  )
end
