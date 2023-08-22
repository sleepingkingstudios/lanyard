# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::SessionsController, type: :controller do
  include Librum::Core::RSpec::Contracts::ControllerContracts

  describe '.middleware' do
    include_contract 'should define middleware',
      Librum::Iam::Authentication::Middleware::DestroySession,
      only: %i[destroy]

    include_contract 'should define middleware',
      Librum::Iam::Authentication::Middleware::RegenerateSession,
      only: %i[create]
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    it { expect(resource).to be_a Librum::Core::Resources::BaseResource }

    it { expect(resource.resource_name).to be == 'sessions' }

    it { expect(resource.singular?).to be true }

    it { expect(resource.skip_authentication.to_a).to be == %w[create destroy] }
  end

  describe '.responders' do
    include_contract 'should respond to format',
      :html,
      using: Librum::Iam::View::SessionsController::Responder
  end

  include_contract 'should define action',
    :create,
    Librum::Iam::Actions::Sessions::Create,
    member: false

  include_contract 'should define action',
    :destroy,
    Cuprum::Rails::Action,
    member: false
end
