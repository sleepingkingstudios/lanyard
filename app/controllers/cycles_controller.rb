# frozen_string_literal: true

# Class for managing job search cycles.
class CyclesController < ViewController
  def self.breadcrumbs
    @breadcrumbs ||= [
      {
        label: 'Home',
        url:   '/'
      },
      {
        label: 'Cycles',
        url:   '/cycles'
      }
    ]
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    components = Lanyard::View::Components::Cycles

    @resource ||=
      Librum::Core::Resources::ViewResource.new(
        default_order:        {
          year:         :desc,
          season_index: :desc
        },
        permitted_attributes: %w[
          active
          name
          slug
          season_index
          ui_eligible
          year
        ],
        resource_class:       Cycle,
        block_component:      components::Block,
        form_component:       components::Form,
        table_component:      components::Table
      )
  end

  middleware Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs.new(
    breadcrumbs: breadcrumbs,
    resource:    resource
  )

  responder :html, Librum::Core::Responders::Html::ResourceResponder

  action :index,   Librum::Core::Actions::Index,     member: false
  action :new,     Cuprum::Rails::Action,            member: false
  action :create,  Lanyard::Actions::Cycles::Create, member: false
  action :show,    Librum::Core::Actions::Show,      member: true
  action :edit,    Librum::Core::Actions::Show,      member: true
  action :update,  Lanyard::Actions::Cycles::Update, member: true
  action :destroy, Librum::Core::Actions::Destroy,   member: true
end
