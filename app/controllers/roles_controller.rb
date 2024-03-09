# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/associations/find'
require 'cuprum/rails/actions/middleware/resources/find'

# Class for managing job applications.
class RolesController < ViewController
  # Responder class for role event requests.
  class Responder < Lanyard::Responders::Html::ResourceResponder
    action :apply do
      match :success do |result|
        role    = result.value&.then { |hsh| hsh['role'] }
        path    = "#{routes.index_path}/active"
        message = 'Successfully applied for role'
        message += " #{role.job_title}" if role&.job_title.present?
        flash   = {
          success: { icon: 'circle-check', message: message }
        }

        redirect_to(path, flash: flash)
      end

      match :failure, error: Lanyard::Errors::Roles::InvalidStatusTransition \
      do |result|
        redirect_back(flash: invalid_status_transition_flash(result.error))
      end

      match :failure do
        role    = result.value&.then { |hsh| hsh['role'] }
        message = 'Unable to apply for role'
        message += " #{role.job_title}" if role&.job_title.present?
        flash = {
          warning: { icon: 'exclamation-triangle', message: message }
        }

        redirect_back(flash: flash)
      end
    end

    action :expire do
      match :success do |result|
        role    = result.value&.then { |hsh| hsh['role'] }
        path    = "#{routes.index_path}/expiring"
        message = 'Successfully expired role'
        message += " #{role.job_title}" if role&.job_title.present?
        flash   = {
          success: { icon: 'circle-check', message: message }
        }

        redirect_to(path, flash: flash)
      end

      match :failure, error: Lanyard::Errors::Roles::InvalidStatusTransition \
      do |result|
        redirect_back(flash: invalid_status_transition_flash(result.error))
      end

      match :failure do
        role    = result.value&.then { |hsh| hsh['role'] }
        message = 'Unable to expire role'
        message += " #{role.job_title}" if role&.job_title.present?
        flash = {
          warning: { icon: 'exclamation-triangle', message: message }
        }

        redirect_back(flash: flash)
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

  responder :html, Responder

  action :index,   Librum::Core::Actions::Index,    member: false
  action :new,     Cuprum::Rails::Actions::New,     member: false
  action :create,  Lanyard::Actions::Roles::Create, member: false
  action :show,    Librum::Core::Actions::Show,     member: true
  action :edit,    Librum::Core::Actions::Show,     member: true
  action :update,  Lanyard::Actions::Roles::Update, member: true
  action :destroy, Librum::Core::Actions::Destroy,  member: true

  action :active,   Lanyard::Actions::Roles::Active,   member: false
  action :apply,    Lanyard::Actions::Roles::Apply,    member: true
  action :expire,   Lanyard::Actions::Roles::Expire,   member: true
  action :expiring, Lanyard::Actions::Roles::Expiring, member: false
  action :inactive, Lanyard::Actions::Roles::Inactive, member: false
end
