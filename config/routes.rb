# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :authentication do
    resource :session, only: %i[create destroy]
  end

  resources :job_searches, path: '/job-searches'

  get '*path',
    to:          'home#not_found',
    constraints: { path: /(?!api).*/ }
end
