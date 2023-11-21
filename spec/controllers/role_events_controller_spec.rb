# frozen_string_literal: true

require 'cuprum/rails/rspec/contracts/responder_contracts'

require 'rails_helper'

RSpec.describe RoleEventsController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '::Responder' do
    include Cuprum::Rails::RSpec::Contracts::ResponderContracts
    include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

    subject(:responder) { described_class.new(**constructor_options) }

    let(:described_class) { super()::Responder }
    let(:action_name)     { 'implement' }
    let(:controller)      { RoleEventsController.new } # rubocop:disable RSpec/DescribedClass
    let(:member_action)   { false }
    let(:request)         { Cuprum::Rails::Request.new }
    let(:resource)        { RoleEventsController.resource } # rubocop:disable RSpec/DescribedClass
    let(:constructor_options) do
      {
        action_name:   action_name,
        controller:    controller,
        member_action: member_action,
        request:       request
      }
    end

    describe '#call' do
      let(:controller_name) { 'CustomController' }
      let(:result)          { Cuprum::Result.new }
      let(:response)        { responder.call(result) }

      context 'when initialized with action_name: "create"' do
        let(:action_name) { 'create' }

        # rubocop:disable RSpec/MultipleMemoizedHelpers
        describe 'with a failing result with an InvalidStatusTransition error' \
        do
          let(:error) do
            Lanyard::Errors::Roles::InvalidStatusTransition.new(
              current_status: 'countdown',
              status:         'reentry',
              valid_statuses: %w[suborbital orbital aerocapture]
            )
          end
          let(:result) { Cuprum::Result.new(error: error) }
          let(:message) do
            'Unable to transition Role from status "Countdown" to status ' \
              '"Reentry"'
          end

          include_contract 'should render page',
            'Librum::Core::View::Pages::Resources::NewPage',
            flash: lambda {
              {
                warning: {
                  icon:    'exclamation-triangle',
                  message: message
                }
              }
            }
        end
        # rubocop:enable RSpec/MultipleMemoizedHelpers
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
        be_a(Librum::Core::Actions::Middleware::Associations::Parent)
          .and(satisfy { |middleware| middleware.association.name == 'role' })
      }
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:expected_actions) do
      Set.new(
        %w[
          index
          new
          create
          show
          edit
          update
        ]
      )
    end
    let(:permitted_attributes) do
      %w[
        data
        event_date
        event_index
        notes
        role_id
        slug
        summary
        type
      ]
    end

    it { expect(resource).to be_a Librum::Core::Resources::ViewResource }

    it { expect(resource.actions).to be == expected_actions }

    it { expect(resource.default_order).to be == :slug }

    it { expect(resource.parent).to be RolesController.resource }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it { expect(resource.resource_class).to be == RoleEvent }

    it { expect(resource.resource_name).to be == 'events' }

    it 'should define the block component' do
      expect(resource.block_component)
        .to be Lanyard::View::RoleEvents::Block
    end

    it 'should define the form component' do
      expect(resource.form_component)
        .to be Lanyard::View::RoleEvents::Form
    end

    it 'should define the table component' do
      expect(resource.table_component)
        .to be Lanyard::View::RoleEvents::Table
    end
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: described_class::Responder

    include_contract 'should not respond to format', :json
  end

  include_contract 'should define action',
    :create,
    Lanyard::Actions::RoleEvents::Create,
    member: false

  include_contract 'should define action',
    :edit,
    Lanyard::Actions::RoleEvents::Show,
    member: true

  include_contract 'should define action',
    :index,
    Lanyard::Actions::RoleEvents::Index,
    member: false

  include_contract 'should define action',
    :show,
    Lanyard::Actions::RoleEvents::Show,
    member: true

  include_contract 'should define action',
    :new,
    Cuprum::Rails::Actions::New,
    member: false

  include_contract 'should define action',
    :update,
    Lanyard::Actions::RoleEvents::Update,
    member: true
end
