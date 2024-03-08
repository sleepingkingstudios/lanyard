# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/contracts/responder_contracts'

RSpec.describe RolesController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '::Responder' do
    include Cuprum::Rails::RSpec::Contracts::ResponderContracts
    include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

    subject(:responder) { described_class.new(**constructor_options) }

    let(:described_class) { super()::Responder }
    let(:controller)      { RolesController.new } # rubocop:disable RSpec/DescribedClass
    let(:action_name)     { 'implement' }
    let(:member_action)   { false }
    let(:request)         { Cuprum::Rails::Request.new }
    let(:constructor_options) do
      {
        action_name:   action_name,
        controller:    controller,
        member_action: member_action,
        request:       request
      }
    end

    describe '#call' do
      context 'when initialized with action_name: apply' do
        let(:action_name)   { 'apply' }
        let(:member_action) { true }

        describe 'with a result with an InvalidStatusTransition error' do
          let(:error) do
            Lanyard::Errors::Roles::InvalidStatusTransition.new(
              current_status: Role::Statuses::CLOSED,
              status:         Role::Statuses::APPLIED,
              valid_statuses: [Role::Statuses::NEW]
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }
          let(:flash) do
            message =
              'Unable to transition Role from status "Closed" to status ' \
              '"Applied"'

            {
              warning: {
                icon:    'exclamation-triangle',
                message: message
              }
            }
          end

          include_contract 'should redirect back', flash: -> { flash }
        end

        describe 'with a failing result' do
          let(:result) { Cuprum::Rails::Result.new(status: :failure) }
          let(:flash) do
            {
              warning: {
                icon:    'exclamation-triangle',
                message: 'Unable to apply for role'
              }
            }
          end

          include_contract 'should redirect back', flash: -> { flash }
        end

        describe 'with a passing result' do
          let(:role) do
            FactoryBot.build(
              :role,
              job_title: 'Monster Trainer',
              slug:      'custom-role'
            )
          end
          let(:result) { Cuprum::Rails::Result.new(value: { 'role' => role }) }
          let(:flash) do
            {
              success: {
                icon:    'circle-check',
                message: "Successfully applied for role #{role.job_title}"
              }
            }
          end

          include_contract 'should redirect to',
            '/roles/active',
            flash: -> { flash }
        end
      end
    end
  end

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
            association:      have_attributes(name: 'cycle'),
            association_type: :belongs_to
          )
      },
      except: %i[destroy]

    include_contract 'should define middleware',
      lambda {
        be_a(Cuprum::Rails::Actions::Middleware::Resources::Find)
          .and have_attributes(
            resource:           have_attributes(name: 'cycles'),
            only_form_actions?: true
          )
      },
      only: %i[create edit new update]
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:default_order) { { last_event_at: :desc } }
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

    it { expect(resource.entity_class).to be == Role }

    it { expect(resource.name).to be == 'roles' }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it 'should define the block component' do
      expect(resource.block_component)
        .to be Lanyard::View::Roles::Block
    end

    it 'should define the form component' do
      expect(resource.form_component)
        .to be Lanyard::View::Roles::Form
    end

    it 'should define the table component' do
      expect(resource.table_component)
        .to be Lanyard::View::Roles::Table
    end
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: described_class::Responder

    include_contract 'should not respond to format', :json
  end

  include_contract 'should define action',
    :active,
    Lanyard::Actions::Roles::Active,
    member: false

  include_contract 'should define action',
    :apply,
    Lanyard::Actions::Roles::Apply,
    member: true

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
    :expiring,
    Lanyard::Actions::Roles::Expiring,
    member: false

  include_contract 'should define action',
    :inactive,
    Lanyard::Actions::Roles::Inactive,
    member: false

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
