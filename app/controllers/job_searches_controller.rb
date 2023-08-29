# frozen_string_literal: true

# Manages JobSearch records.
class JobSearchesController < ViewController
  def self.breadcrumbs
    @breadcrumbs ||= [
      { label: 'Home', url: '/' },
      { label: 'Job Searches', url: '/job-searches' }
    ]
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    @resource ||= Librum::Core::Resources::ViewResource.new(
      base_path:            '/job-searches',
      default_order:        :start_date,
      permitted_attributes: %w[
        end_date
        slug
        start_date
      ],
      resource_class:       JobSearch,
      block_component:      Lanyard::View::Components::JobSearches::Block,
      form_component:       Lanyard::View::Components::JobSearches::Form,
      table_component:      Lanyard::View::Components::JobSearches::Table
    )
  end

  middleware Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs.new(
    breadcrumbs: breadcrumbs,
    resource:    resource
  )

  responder :html, Librum::Core::Responders::Html::ResourceResponder

  action :create,  Lanyard::Actions::JobSearches::Create, member: false
  action :index,   Librum::Core::Actions::Index,          member: false
  action :new,     Cuprum::Rails::Action,                 member: false
  action :show,    Librum::Core::Actions::Show,           member: true
  action :edit,    Librum::Core::Actions::Show,           member: true
  action :update,  Lanyard::Actions::JobSearches::Update, member: true
  action :destroy, Librum::Core::Actions::Destroy,        member: true
end
