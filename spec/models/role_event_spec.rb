# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:        '1982-07-09-0-event',
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

  describe '.valid_for?' do
    Role::Statuses.each_value do |status|
      describe "with a role with status #{status.inspect}" do
        let(:role) { FactoryBot.build(:role, status: status) }

        it { expect(described_class.valid_for?(role)).to be true }
      end
    end
  end

  describe '#update_role' do
    let(:repository)    { Cuprum::Rails::Repository.new }
    let(:command)       { subject.update_role(repository: repository) }
    let(:command_class) { Lanyard::Models::Roles::UpdateLastEvent }

    it { expect(command).to be_a command_class }

    it { expect(command.repository).to be repository }
  end

  describe '#validate_role' do
    let(:repository)    { Cuprum::Rails::Repository.new }
    let(:command)       { subject.validate_role(repository: repository) }
    let(:command_class) { Lanyard::Models::RoleEvents::ValidateRole }

    it { expect(command).to be_a command_class }

    it { expect(command.repository).to be repository }
  end
end
