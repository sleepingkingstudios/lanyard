# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:        '1982-07-09-event',
      event_date:  Date.new(1982, 7, 9),
      event_index: 0,
      data:        {},
      notes:       <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  include_contract 'should be a role event',
    summary: 'Generic role event',
    type:    ''

  describe '.event_types' do
    let(:expected) do
      {
        'Event'   => '',
        'Applied' => 'RoleEvents::AppliedEvent'
      }
    end

    include_examples 'should define class reader', :event_types

    it { expect(described_class.event_types).to deep_match expected }
  end

  describe '.name_for' do
    it { expect(described_class).to respond_to(:name_for).with(1).argument }

    describe 'with nil' do
      it { expect(described_class.name_for nil).to be == 'Event' }
    end

    describe 'with an empty String' do
      it { expect(described_class.name_for '').to be == 'Event' }
    end

    describe 'with an event type' do
      let(:type) { RoleEvents::AppliedEvent.name }

      it { expect(described_class.name_for type).to be == 'Applied' }
    end
  end
end
