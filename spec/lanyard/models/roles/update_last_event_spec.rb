# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::UpdateLastEvent do
  subject(:command) { described_class.new(repository: repository, **options) }

  let(:repository) { Cuprum::Rails::Repository.new }
  let(:options)    { {} }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository)
        .and_any_keywords
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
    let(:role_event) do
      FactoryBot.build(
        :event,
        role:       role,
        event_date: 1.day.ago
      )
    end

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

    it 'should set the role last_event_at timestamp' do
      expect { command.call(role: role, role_event: role_event) }
        .to(
          change { role.reload.last_event_at.to_i }
          .to be == role_event.event_date.beginning_of_day.to_i
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
