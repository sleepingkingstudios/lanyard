# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.4'

gem 'rails', '~> 7.0.8'

gem 'pg', '~> 1.5' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.0'

### Engines
gem 'librum-core',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/librum-core'
gem 'librum-iam',
  branch: 'main',
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

  gem 'rspec', '~> 3.12'
  gem 'rspec-rails', '~> 6.0'
  gem 'rspec-sleeping_king_studios', '~> 2.7'

  gem 'rubocop', '~> 1.57', '>= 1.57.2'
  gem 'rubocop-rails', '~> 2.22', '>= 2.22.1' # https://docs.rubocop.org/rubocop-rails/
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.25' # https://docs.rubocop.org/rubocop-rspec/

  gem 'simplecov', '~> 0.22'
end

group :development do
  gem 'sleeping_king_studios-tasks', '~> 0.4', '>= 0.4.1'

  gem 'web-console' # Use console on exceptions pages
end
