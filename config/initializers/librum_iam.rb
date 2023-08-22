# frozen_string_literal: true

Librum::Iam::Engine.instance_exec do
  config.authentication_session_path = '/authentication/session'
end
