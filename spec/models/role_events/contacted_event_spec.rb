# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvents::ContactedEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:        '1982-07-09-0-contacted',
      event_date:  Date.new(1982, 7, 9),
      event_index: 0,
      data:        {},
      notes:       <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  describe '.valid_for?' do
    Role::Statuses.each_value do |status|
      describe "with a role with status #{status.inspect}" do
        let(:role) { FactoryBot.build(:role, status: status) }

        it { expect(described_class.valid_for?(role)).to be true }
      end
    end
  end

  include_contract 'should be a role event',
    summary: 'Contacted by recruiter or agent',
    type:    'RoleEvents::ContactedEvent'

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
