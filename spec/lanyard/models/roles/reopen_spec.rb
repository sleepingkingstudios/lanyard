# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::Reopen do
  subject(:command) { described_class.new(repository: repository) }

  let(:repository) { Cuprum::Rails::Repository.new }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository)
    end
  end

  describe '#call' do
    let(:role) { FactoryBot.create(:role, :with_cycle) }

    before(:example) do
      FactoryBot.create(
        :closed_event,
        role:        role,
        event_date:  Time.current.to_date,
        event_index: role.events.count
      )

      role.update(status: Role::Statuses::CLOSED)
    end

    it { expect(command).to be_callable.with(0).arguments.and_keywords(:role) }

    describe 'with role: a role with status "new"' do
      let(:role) do
        FactoryBot.create(:role, :new, :with_cycle, :with_events)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should update the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == Role::Statuses::NEW
          )
      end
    end

    describe 'with role: a role with status "applied"' do
      let(:role) do
        FactoryBot.create(:role, :applied, :with_cycle, :with_events)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should update the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == Role::Statuses::APPLIED
          )
      end
    end

    describe 'with role: a role with status "interviewing"' do
      let(:role) do
        FactoryBot.create(:role, :interviewing, :with_cycle, :with_events)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should update the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == Role::Statuses::INTERVIEWING
          )
      end
    end

    describe 'with role: a role with status "offered"' do
      let(:role) do
        FactoryBot.create(:role, :offered, :with_cycle, :with_events)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should update the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == Role::Statuses::OFFERED
          )
      end
    end

    describe 'with role: a role with status "closed"' do
      let(:role) do
        FactoryBot.create(:role, :accepted, :with_cycle, :with_events)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should update the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == Role::Statuses::OFFERED
          )
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
