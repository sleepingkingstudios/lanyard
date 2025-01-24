# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvents::ReferredEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:        '1982-07-09-0-applied',
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
      [
        Role::Statuses::NEW,
        Role::Statuses::APPLIED,
        Role::Statuses::INTERVIEWING
      ]
  end

  include_contract 'should be a status event',
    status:         described_class::STATUS,
    summary:        'Referred for the role',
    type:           'RoleEvents::ReferredEvent',
    valid_statuses: described_class::VALID_STATUSES

  describe '#update_role' do
    let(:repository)    { Cuprum::Rails::Repository.new }
    let(:command_class) { Lanyard::Models::Roles::UpdateStatus }
    let(:command)       { event.update_role(repository: repository) }
    let(:role)          { FactoryBot.create(:role, :with_cycle, status) }
    let(:status)        { Role::Statuses::NEW }

    it { expect(command).to be_a command_class }

    it { expect(command.repository).to be repository }

    describe 'with a role with status: "new"' do
      let(:status) { Role::Statuses::NEW }

      it 'should update the role status' do
        expect { command.call(role: role, role_event: event) }.to(
          change { role.reload.status }
            .to eq(event.status)
        )
      end
    end

    Role::Statuses.each_value do |role_status|
      next if role_status == Role::Statuses::NEW

      describe "with a role with status: #{role_status.inspect}" do
        let(:status) { role_status }

        it 'should not update the role status' do
          expect { command.call(role: role, role_event: event) }
            .not_to(change { role.reload.status })
        end
      end
    end
  end
end
