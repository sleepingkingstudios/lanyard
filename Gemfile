# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.0.7'

gem 'pg', '~> 1.5' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.0'

### Assets
gem 'importmap-rails' # Use JavaScript with ESM import maps
gem 'sprockets-rails' # The original asset pipeline for Rails

group :development, :test do
  gem 'byebug'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'rspec', '~> 3.12'
  gem 'rspec-rails', '~> 6.0'
  gem 'rspec-sleeping_king_studios', '~> 2.7'

  gem 'rubocop', '~> 1.56'
  gem 'rubocop-rails', '~> 2.20' # https://docs.rubocop.org/rubocop-rails/
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.23' # https://docs.rubocop.org/rubocop-rspec/

  gem 'simplecov', '~> 0.22'
end

group :development do
  gem 'web-console' # Use console on exceptions pages
end
