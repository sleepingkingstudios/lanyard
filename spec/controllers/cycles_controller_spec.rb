# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CyclesController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.breadcrumbs' do
    let(:expected) do
      [
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
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:default_order) do
      {
        year:         :desc,
        season_index: :desc
      }
    end
    let(:permitted_attributes) do
      %w[
        active
        name
        slug
        season_index
        ui_eligible
        year
      ]
    end

    it { expect(resource).to be_a Librum::Core::Resources::ViewResource }

    it { expect(resource.default_order).to be == default_order }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it { expect(resource.resource_class).to be == Cycle }

    it { expect(resource.resource_name).to be == 'cycles' }

    it 'should define the block component' do
      expect(resource.block_component)
        .to be Lanyard::View::Components::Cycles::Block
    end

    it 'should define the form component' do
      expect(resource.form_component)
        .to be Lanyard::View::Components::Cycles::Form
    end

    it 'should define the table component' do
      expect(resource.table_component)
        .to be Lanyard::View::Components::Cycles::Table
    end
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: Librum::Core::Responders::Html::ResourceResponder

    include_contract 'should not respond to format', :json
  end

  include_contract 'should define action',
    :create,
    Lanyard::Actions::Cycles::Create,
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
    Cuprum::Rails::Action,
    member: false

  include_contract 'should define action',
    :show,
    Librum::Core::Actions::Show,
    member: true

  include_contract 'should define action',
    :update,
    Lanyard::Actions::Cycles::Update,
    member: true
end
