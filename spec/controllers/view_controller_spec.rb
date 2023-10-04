# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.middleware' do
    include_contract 'should define middleware', lambda {
      be_a(Librum::Core::Actions::View::Middleware::PageNavigation)
        .and have_attributes(navigation: described_class.navigation)
    }
  end

  describe '.navigation' do
    let(:expected) do
      {
        icon:  'briefcase',
        label: 'Home',
        items: [
          {
            label: 'Cycles',
            url:   '/cycles'
          }
        ]
      }
    end

    it 'should define the class reader' do
      expect(described_class)
        .to define_reader(:navigation)
        .with_value(expected)
    end
  end
end
