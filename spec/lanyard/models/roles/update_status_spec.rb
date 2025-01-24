# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::UpdateStatus do
  subject(:command) { described_class.new(repository: repository, **options) }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:options)    { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository)
    end
  end

  describe '#call' do
    let(:role) do
      FactoryBot.create(
        :role,
        :with_cycle,
        created_at:    2.days.ago,
        last_event_at: 2.days.ago,
        updated_at:    1.hour.ago
      )
    end
    let(:role_event) do
      FactoryBot.build(
        :applied_event,
        role:       role,
        event_date: 1.day.ago
      )
    end
    let(:current_time) { Time.current }

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:role, :role_event)
    end

    it 'should return a passing result' do
      expect(command.call(role: role, role_event: role_event))
        .to be_a_passing_result
        .with_value(role)
    end

    it 'should set the role status' do
      expect { command.call(role: role, role_event: role_event) }
        .to(
          change { role.reload.status }
          .to be == role_event.status
        )
    end

    it 'should set the role last_event_at timestamp' do
      expect { command.call(role: role, role_event: role_event) }
        .to(
          change { role.reload.last_event_at.to_i }
          .to be == role_event.event_date.beginning_of_day.to_i
        )
    end

    it 'should set the role status timestamp' do
      expect { command.call(role: role, role_event: role_event) }
        .to(
          change { role.reload.applied_at.to_i }
          .to be == current_time.to_i
        )
    end

    it 'should set the role updated_at timestamp' do
      expect { command.call(role: role, role_event: role_event) }
        .to(
          change { role.reload.updated_at.to_i }
          .to be == current_time.to_i
        )
    end

    context 'when the timestamp is already set' do
      let(:role) do
        FactoryBot.create(
          :role,
          :with_cycle,
          :interviewing,
          created_at:    2.days.ago,
          last_event_at: 2.days.ago,
          updated_at:    1.hour.ago
        )
      end
      let(:role_event) do
        FactoryBot.build(
          :interview_event,
          role:       role,
          event_date: 1.day.ago
        )
      end

      it 'should return a passing result' do
        expect(command.call(role: role, role_event: role_event))
          .to be_a_passing_result
          .with_value(role)
      end

      it 'should not change the role status' do
        expect { command.call(role: role, role_event: role_event) }
          .not_to(change { role.reload.status })
      end

      it 'should set the role last_event_at timestamp' do
        expect { command.call(role: role, role_event: role_event) }
          .to(
            change { role.reload.last_event_at.to_i }
            .to be == role_event.event_date.beginning_of_day.to_i
          )
      end

      it 'should set the role status timestamp' do
        expect { command.call(role: role, role_event: role_event) }
          .to(
            change { role.reload.interviewing_at.to_i }
            .to be == current_time.to_i
          )
      end

      it 'should set the role updated_at timestamp' do
        expect { command.call(role: role, role_event: role_event) }
          .to(
            change { role.reload.updated_at.to_i }
            .to be == current_time.to_i
          )
      end
    end

    context 'when initialized with options: { update_status: }' do
      let(:update_status) { ->(**) {} }
      let(:options)       { super().merge(update_status: update_status) }

      it 'should yield the role and role event to the conditional' do # rubocop:disable RSpec/ExampleLength
        spy = instance_double(Proc, call: nil)

        described_class
          .new(repository: repository, **options, update_status: spy)
          .call(role: role, role_event: role_event)

        expect(spy)
          .to have_received(:call)
          .with(role: role, role_event: role_event)
      end

      context 'when the conditional returns false' do
        let(:update_status) { ->(**) { false } }

        it 'should not set the role status' do
          expect { command.call(role: role, role_event: role_event) }
            .not_to(change { role.reload.status })
        end

        it 'should not set the role status timestamp' do
          expect { command.call(role: role, role_event: role_event) }
            .not_to(change { role.reload.applied_at })
        end
      end

      context 'when the conditional returns true' do
        let(:update_status) { ->(**) { true } }

        it 'should set the role status' do
          expect { command.call(role: role, role_event: role_event) }
            .to(
              change { role.reload.status }
              .to be == role_event.status
            )
        end

        it 'should set the role status timestamp' do
          expect { command.call(role: role, role_event: role_event) }
            .to(
              change { role.reload.applied_at.to_i }
              .to be == current_time.to_i
            )
        end
      end
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    context 'when initialized with options: value' do
      let(:options) { { option: 'value' } }

      it { expect(command.options).to be == options }
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
