# frozen_string_literal: true

# Class for managing job application events.
class RoleEventsController < ViewController
  # Responder class for role event requests.
  class Responder < Librum::Core::Responders::Html::ResourceResponder
    action :create do
      match :failure, error: Lanyard::Errors::Roles::InvalidStatusTransition \
      do |result|
        render_component(
          result,
          action: 'new',
          flash:  invalid_status_transition_flash(result.error)
        )
      end
    end

    private

    def invalid_status_transition_flash(error)
      current = error.current_status.titleize.inspect
      status  = error.status.titleize.inspect
      message =
        "Unable to transition Role from status #{current} to status #{status}"

      { warning: { icon: 'exclamation-triangle', message: message } }
    end
  end

  def self.breadcrumbs # rubocop:disable Metrics/MethodLength
    @breadcrumbs ||= [
      {
        label: 'Home',
        url:   '/'
      },
      {
        label: 'Roles',
        url:   '/roles'
      },
      {
        label: 'Role',
        url:   '/roles/:role_id'
      },
      {
        label: 'Events',
        url:   '/roles/:role_id/events'
      }
    ]
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    components = Lanyard::View::RoleEvents

    @resource ||=
      Librum::Core::Resources::ViewResource.new(
        actions:              %w[index new create show edit update],
        default_order:        :slug,
        name:                 'events',
        parent:               RolesController.resource,
        permitted_attributes: %w[
          data
          event_date
          notes
          role_id
          slug
          type
        ],
        resource_class:       RoleEvent,
        form_component:       components::Form,
        table_component:      components::Table
      )
  end

  middleware Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs.new(
    breadcrumbs: breadcrumbs,
    resource:    resource
  )

  middleware(
    Librum::Core::Actions::Middleware::Associations::Parent.new(
      association_name: 'role'
    )
  )

  responder :html, RoleEventsController::Responder

  action :index,  Librum::Core::Actions::Index,         member: false
  action :new,    Cuprum::Rails::Actions::New,          member: false
  action :create, Lanyard::Actions::RoleEvents::Create, member: false
  action :show,   Librum::Core::Actions::Show,          member: true
  action :edit,   Librum::Core::Actions::Show,          member: true
  action :update, Lanyard::Actions::RoleEvents::Update, member: true
end
