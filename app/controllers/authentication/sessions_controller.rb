# frozen_string_literal: true

module Authentication
  # Controller for managing authentication sessions.
  class SessionsController < Librum::Iam::View::SessionsController
    middleware Librum::Iam::Authentication::Middleware::DestroySession,
      only: %i[destroy]

    middleware Librum::Iam::Authentication::Middleware::RegenerateSession,
      only: %i[create]
  end
end
