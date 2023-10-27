# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.breadcrumbs' do
    let(:expected) do
      [
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

    it 'should define the class reader' do
      expect(described_class)
        .to define_reader(:breadcrumbs)
        .with_value(expected)
    end
  end

  describe '.middleware' do
    include_contract 'should define middleware', lambda {
      be_a(Librum::Core::Actions::View::Middleware::ResourceBreadcrumbs)
        .and have_attributes(
          breadcrumbs: described_class.breadcrumbs,
          resource:    described_class.resource
        )
    }

    include_contract 'should define middleware', lambda {
      be_a(Librum::Core::Actions::View::Middleware::PageNavigation)
        .and have_attributes(navigation: ViewController.navigation)
    }

    include_contract 'should define middleware',
      lambda {
        be_a(Cuprum::Rails::Actions::Middleware::Associations::Find)
          .and have_attributes(
            association:      have_attributes(association_name: 'cycle'),
            association_type: :belongs_to
          )
      },
      except: %i[destroy]

    include_contract 'should define middleware',
      lambda {
        be_a(Cuprum::Rails::Actions::Middleware::Resources::Find)
          .and have_attributes(
            resource:           have_attributes(resource_name: 'cycles'),
            only_form_actions?: true
          )
      },
      only: %i[create edit new update]
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:default_order) { { created_at: :desc } }
    let(:permitted_attributes) do
      %w[
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
      ]
    end

    it { expect(resource).to be_a Librum::Core::Resources::ViewResource }

    it { expect(resource.default_order).to be == default_order }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it { expect(resource.resource_class).to be == Role }

    it { expect(resource.resource_name).to be == 'roles' }
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: Librum::Core::Responders::Html::ResourceResponder

    include_contract 'should not respond to format', :json
  end

  include_contract 'should define action',
    :create,
    Lanyard::Actions::Roles::Create,
    member: false

  include_contract 'should define action',
    :destroy,
    Librum::Core::Actions::Destroy,
    member: true

  include_contract 'should define action',
    :edit,
    Librum::Core::Actions::Show,
    member: true

  include_contract 'should define action',
    :index,
    Librum::Core::Actions::Index,
    member: false

  include_contract 'should define action',
    :new,
    Cuprum::Rails::Actions::New,
    member: false

  include_contract 'should define action',
    :show,
    Librum::Core::Actions::Show,
    member: true

  include_contract 'should define action',
    :update,
    Lanyard::Actions::Roles::Update,
    member: true
end
