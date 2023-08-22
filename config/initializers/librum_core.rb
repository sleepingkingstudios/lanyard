# frozen_string_literal: true

Librum::Core::Engine.instance_exec do
  config.to_prepare do
    # Add authentication config to all controller resources.
    Librum::Core::Resources::BaseResource.include(Librum::Iam::Resource)

    # Authenticate View requests.
    Librum::Core::ViewController.include(Librum::Iam::SessionMiddleware)

    # Render the login page after an authentication failure.
    Librum::Core::Responders::Html::ViewResponder
      .include(Librum::Iam::Responders::Html::AuthenticatedResponder)
  end
end
