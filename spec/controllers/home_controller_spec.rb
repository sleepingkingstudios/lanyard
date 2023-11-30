# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.breadcrumbs' do
    let(:expected) { [{ active: true, label: 'Home', url: '/' }] }

    it 'should define the class reader' do
      expect(described_class)
        .to define_reader(:breadcrumbs)
        .with_value(expected)
    end
  end

  describe '.middleware' do
    include_contract 'should define middleware', lambda {
      be_a(Librum::Core::Actions::View::Middleware::PageBreadcrumbs)
        .and have_attributes(breadcrumbs: described_class.breadcrumbs)
    }

    include_contract 'should define middleware', lambda {
      be_a(Librum::Core::Actions::View::Middleware::PageNavigation)
        .and have_attributes(navigation: ViewController.navigation)
    }
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    it { expect(resource).to be_a Librum::Core::Resources::BaseResource }

    it { expect(resource.name).to be == 'home' }
  end

  include_contract 'should define action',
    :not_found,
    Librum::Core::Actions::View::NotFound,
    member: false
end
