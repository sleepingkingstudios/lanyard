# frozen_string_literal: true

require 'rails_helper'

require 'lanyard/responders/html/resource_responder'

require 'stannum/errors'

require 'cuprum/collections'
require 'cuprum/rails/rspec/contracts/responder_contracts'

RSpec.describe Lanyard::Responders::Html::ResourceResponder do
  include Cuprum::Rails::RSpec::Contracts::ResponderContracts
  include Librum::Core::RSpec::Contracts::Responders::HtmlContracts

  subject(:responder) { described_class.new(**constructor_options) }

  shared_context 'when the page is defined' do |component_name|
    let(:component_class) { component_name.constantize }

    example_class component_name, Librum::Core::View::Components::Page
  end

  let(:action_name)   { 'implement' }
  let(:controller)    { CustomController.new }
  let(:member_action) { false }
  let(:request)       { Cuprum::Rails::Request.new }
  let(:resource_options) do
    { name: 'roles' }
  end
  let(:constructor_options) do
    {
      action_name:   action_name,
      controller:    controller,
      member_action: member_action,
      request:       request
    }
  end

  include_contract 'should implement the responder methods',
    controller_name: 'CustomController'

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe '#call' do
    let(:controller_name) { 'CustomController' }
    let(:result)          { Cuprum::Result.new }
    let(:response)        { responder.call(result) }
    let(:expected_page) do
      'Lanyard::View::Custom::ImplementPage'
    end

    context 'when initialized with a plural resource' do
      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_contract 'should render the missing page'

        wrap_context 'when the page is defined',
          'Lanyard::View::Custom::ImplementPage' \
        do
          include_contract 'should render page',
            'Lanyard::View::Custom::ImplementPage',
            http_status: :internal_server_error
        end
      end

      describe 'with a passing result' do
        let(:value)  { { ok: true } }
        let(:result) { Cuprum::Result.new(value: value) }

        include_contract 'should render the missing page'

        wrap_context 'when the page is defined',
          'Lanyard::View::Custom::ImplementPage' \
        do
          include_contract 'should render page',
            'Lanyard::View::Custom::ImplementPage',
            http_status: :ok
        end
      end
    end

    context 'when initialized with a singular resource' do
      let(:resource_options) { super().merge(name: 'rocket', singular: true) }

      describe 'with a failing result' do
        let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
        let(:result) { Cuprum::Result.new(error: error) }

        include_contract 'should render the missing page'

        wrap_context 'when the page is defined',
          'Lanyard::View::Custom::ImplementPage' \
        do
          include_contract 'should render page',
            'Lanyard::View::Custom::ImplementPage',
            http_status: :internal_server_error
        end
      end

      describe 'with a passing result' do
        let(:value)  { { ok: true } }
        let(:result) { Cuprum::Result.new(value: value) }

        include_contract 'should render the missing page'

        wrap_context 'when the page is defined',
          'Lanyard::View::Custom::ImplementPage' \
        do
          include_contract 'should render page',
            'Lanyard::View::Custom::ImplementPage',
            http_status: :ok
        end
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
