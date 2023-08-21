# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '*path',
    to:          'home#not_found',
    constraints: { path: /(?!api).*/ }
end
