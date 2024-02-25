# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::UpdateLastEvent do
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
    let(:current_time) { Time.current }
    let(:role) do
      FactoryBot.create(
        :role,
        :with_cycle,
        created_at: 2.days.ago,
        updated_at: 1.hour.ago
      )
    end

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:role)
    end

    it 'should return a passing result' do
      expect(command.call(role: role))
        .to be_a_passing_result
        .with_value(role)
    end

    it 'should set the role last_event_at timestamp' do
      expect { command.call(role: role) }
        .to(
          change { role.reload.last_event_at.to_i }
          .to be == role.created_at.to_i
        )
    end

    it 'should set the role updated_at timestamp' do
      expect { command.call(role: role) }
        .to(
          change { role.reload.updated_at.to_i }
          .to be == current_time.to_i
        )
    end

    context 'when the role has many events' do
      let(:expected_date) do
        role.events.order(event_date: :desc).first.event_date.beginning_of_day
      end

      before(:example) do
        FactoryBot.create(
          :contacted_event,
          role:       role,
          event_date: 3.days.ago
        )
        FactoryBot.create(
          :applied_event,
          role:       role,
          event_date: 2.days.ago
        )
        FactoryBot.create(
          :interview_event,
          role:       role,
          event_date: 1.day.ago
        )
      end

      it 'should set the role last_event_at timestamp' do
        expect { command.call(role: role) }
          .to(
            change { role.reload.last_event_at.to_i }
            .to be == expected_date.to_i
          )
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
