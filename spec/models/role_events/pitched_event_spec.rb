# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvents::PitchedEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:        '1982-07-09-0-pitched',
      event_date:  Date.new(1982, 7, 9),
      event_index: 0,
      data:        {},
      notes:       <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  describe '::STATUS' do
    include_examples 'should define immutable constant',
      :STATUS,
      Role::Statuses::APPLIED
  end

  describe '::VALID_STATUSES' do
    include_examples 'should define immutable constant',
      :VALID_STATUSES,
      [Role::Statuses::NEW]
  end

  include_contract 'should be a status event',
    status:         described_class::STATUS,
    summary:        'Pitched for the role by recruiter',
    type:           'RoleEvents::PitchedEvent',
    valid_statuses: described_class::VALID_STATUSES
end
