# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:       '1982-07-09-event',
      event_date: Date.new(1982, 7, 9),
      data:       {},
      notes:      <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  include_contract 'should be a role event', type: ''
end
