# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::UpdateStatus do
  subject(:command) do
    described_class.new(repository: repository, status: status)
  end

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:status)     { 'indeterminate' }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository, :status)
    end
  end

  describe '#call' do
    let(:role)   { FactoryBot.create(:role, :with_cycle) }
    let(:status) { Role::Statuses::APPLIED }

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:role)
    end

    describe 'with an invalid status' do
      let(:status) { 'indeterminate' }
      let(:expected_error) do
        Lanyard::Errors::Roles::InvalidStatus.new(status: status)
      end

      it 'should return a failing result' do
        expect(command.call(role: role))
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not update the role' do
        expect { command.call(role: role) }
          .not_to(change { role.reload.attributes })
      end
    end

    describe 'with a valid status' do
      let(:current_time) { Time.current }
      let(:status)       { Role::Statuses::APPLIED }

      before(:example) do
        allow(Time).to receive(:current).and_return(current_time)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should set the role status' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.status }
            .to be == status
          )
      end

      it 'should set the role status timestamp' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.applied_at.to_i }
            .to be == current_time.to_i
          )
      end

      context 'when the timestamp is already set' do
        let(:role)   { FactoryBot.create(:role, :with_cycle, :interviewing) }
        let(:status) { Role::Statuses::INTERVIEWING }

        it 'should return a passing result' do
          expect(command.call(role: role))
            .to be_a_passing_result
            .with_value(role)
        end

        it 'should not change the role status' do
          expect { command.call(role: role) }
            .not_to(change { role.reload.status })
        end

        it 'should set the role status timestamp' do
          expect { command.call(role: role) }
            .to(
              change { role.reload.interviewing_at.to_i }
              .to be == current_time.to_i
            )
        end
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end
end
