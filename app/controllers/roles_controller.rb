# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/associations/find'
require 'cuprum/rails/actions/middleware/resources/find'

# Class for managing job applications.
class RolesController < ViewController
  def self.breadcrumbs
    @breadcrumbs ||= [
      {
        label: 'Home',
        url:   '/'
      },
      {
        label: 'Roles',
        url:   '/roles'
      }
    ]
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    components = Lanyard::View::Roles

    @resource ||=
      Librum::Core::Resources::ViewResource.new(
        default_order:        { last_event_at: :desc },
        entity_class:         Role,
        permitted_attributes: %w[
          agency_name
          benefits
          benefits_details
          client_name
          company_name
          compensation
          compensation_type
          contract_duration
          contract_type
          cycle_id
          job_title
          industry
          location
          location_type
          notes
          recruiter_name
          slug
          source
          source_details
          status
          time_zone
        ],
        block_component:      components::Block,
        form_component:       components::Form,
        table_component:      components::Table
      )
  end

  middleware Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs.new(
    breadcrumbs: breadcrumbs,
    resource:    resource
  )

  middleware(
    Cuprum::Rails::Actions::Middleware::Associations::Find.new(
      name:             'cycle',
      association_type: :belongs_to
    ),
    except: %i[destroy]
  )

  middleware(
    Cuprum::Rails::Actions::Middleware::Resources::Find.new(
      name:              'cycles',
      only_form_actions: true
    ),
    only: %i[create edit new update]
  )

  responder :html, Librum::Core::Responders::Html::ResourceResponder

  action :index,   Librum::Core::Actions::Index,    member: false
  action :new,     Cuprum::Rails::Actions::New,     member: false
  action :create,  Lanyard::Actions::Roles::Create, member: false
  action :show,    Librum::Core::Actions::Show,     member: true
  action :edit,    Librum::Core::Actions::Show,     member: true
  action :update,  Lanyard::Actions::Roles::Update, member: true
  action :destroy, Librum::Core::Actions::Destroy,  member: true
end
