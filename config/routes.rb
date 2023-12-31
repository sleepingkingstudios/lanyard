# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :authentication do
    resource :session, only: %i[create destroy]
  end

  resources :cycles

  resources :roles do
    resources :events,
      controller: 'role_events',
      only:       %i[index new create show edit update]
  end

  root to: 'roles#index'

  get '*path',
    to:          'home#not_found',
    constraints: { path: /(?!api).*/ }
end
