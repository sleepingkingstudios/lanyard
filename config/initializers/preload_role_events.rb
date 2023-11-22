# frozen_string_literal: true

events_dir = Rails.root.join('app/models/role_events')

unless Rails.application.config.eager_load
  Rails.application.config.to_prepare do
    Rails.autoloaders.main.eager_load_dir(events_dir)
  end
end
