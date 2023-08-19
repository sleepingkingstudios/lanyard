# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.0.7'

gem 'puma',  '~> 5.0'

### Assets
gem 'importmap-rails' # Use JavaScript with ESM import maps
gem 'sprockets-rails' # The original asset pipeline for Rails

group :development, :test do
  gem 'byebug'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console' # Use console on exceptions pages
end
