# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.9'

gem 'concurrent-ruby', '1.3.4' # @todo: Remove this when upgrading to Rails 7.1.
gem 'rails', '~> 7.1.5', '>= 7.1.5.2'

gem 'pg', '~> 1.5' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.0'

### Engines
gem 'librum-core',
  branch: 'branch/compatibility',
  git:    'https://github.com/sleepingkingstudios/librum-core'
gem 'librum-iam',
  branch: 'branch/compatibility',
  git:    'https://github.com/sleepingkingstudios/librum-iam'

### Assets
gem 'importmap-rails' # Use JavaScript with ESM import maps
gem 'sprockets-rails' # The original asset pipeline for Rails
gem 'stimulus-rails'

### Commands
gem 'cuprum', '~> 1.2'
gem 'cuprum-collections',
  '>= 0.5.0.alpha',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-collections'
gem 'cuprum-rails',
  '>= 0.3.0.alpha',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-rails'
gem 'stannum', '~> 0.3'

### Views
gem 'view_component', '~> 3.0'

group :development, :test do
  gem 'annotate'

  gem 'byebug'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # See https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
  gem 'factory_bot_rails', '~> 6.2'

  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 7.0'
  gem 'rspec-sleeping_king_studios', '~> 2.8'

  gem 'rubocop', '~> 1.79'
  gem 'rubocop-factory_bot', '~> 2.27'
  gem 'rubocop-rails', '~> 2.32' # https://docs.rubocop.org/rubocop-rails/
  gem 'rubocop-rake', '~> 0.7'
  gem 'rubocop-rspec', '~> 3.6' # https://docs.rubocop.org/rubocop-rspec/
  gem 'rubocop-rspec_rails', '~> 2.31' # https://docs.rubocop.org/rubocop-rspec_rails/

  gem 'simplecov', '~> 0.22'
end

group :development do
  gem 'sleeping_king_studios-tasks', '~> 0.4', '>= 0.4.1'

  gem 'web-console' # Use console on exceptions pages
end
