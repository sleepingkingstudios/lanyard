# frozen_string_literal: true

module Lanyard::View::Roles
  # Page component for rendering an individual role.
  class ShowPage < Librum::Core::View::Pages::Resources::ShowPage
    private

    alias role resource_data

    def apply_button
      {
        color:       'primary',
        http_method: 'patch',
        label:       'Apply For Role',
        light:       true,
        url:         apply_role_path(role.slug)
      }
    end

    def buttons
      return super unless role

      buttons = super

      buttons.prepend(apply_button) if role.status == Role::Statuses::NEW

      buttons.prepend(expire_button) if role.expiring?

      buttons
    end

    def expire_button
      {
        color:       'gray',
        http_method: 'patch',
        label:       'Expire Role',
        light:       true,
        url:         expire_role_path(role.slug)
      }
    end
  end
end
