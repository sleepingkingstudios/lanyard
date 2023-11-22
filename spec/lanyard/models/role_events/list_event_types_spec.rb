# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::RoleEvents::ListEventTypes do
  subject(:command) { described_class.new }

  describe '.all_event_types' do
    let(:expected) do
      {
        'Event'     => RoleEvent,
        'Accepted'  => RoleEvents::AcceptedEvent,
        'Applied'   => RoleEvents::AppliedEvent,
        'Closed'    => RoleEvents::ClosedEvent,
        'Contacted' => RoleEvents::ContactedEvent,
        'Declined'  => RoleEvents::DeclinedEvent,
        'Expired'   => RoleEvents::ExpiredEvent,
        'Interview' => RoleEvents::InterviewEvent,
        'Offered'   => RoleEvents::OfferedEvent,
        'Pitched'   => RoleEvents::PitchedEvent,
        'Rejected'  => RoleEvents::RejectedEvent,
        'Withdrawn' => RoleEvents::WithdrawnEvent
      }
    end

    include_examples 'should define class reader', :all_event_types

    it { expect(described_class.all_event_types).to deep_match(expected) }
  end

  describe '#call' do
    it { expect(command).to be_callable.with(1).argument }

    describe 'with a role with status "new"' do
      let(:role) { FactoryBot.build(:role, :new) }
      let(:expected) do
        [
          ['Event',     ''],
          ['Applied',   RoleEvents::AppliedEvent.name],
          ['Closed',    RoleEvents::ClosedEvent.name],
          ['Contacted', RoleEvents::ContactedEvent.name],
          ['Expired',   RoleEvents::ExpiredEvent.name],
          ['Pitched',   RoleEvents::PitchedEvent.name]
        ]
      end

      it 'should return a passing result' do
        expect(command.call(role))
          .to be_a_passing_result
          .with_value(expected)
      end
    end

    describe 'with a role with status "applied"' do
      let(:role) { FactoryBot.build(:role, :applied) }
      let(:expected) do
        [
          ['Event',     ''],
          ['Closed',    RoleEvents::ClosedEvent.name],
          ['Contacted', RoleEvents::ContactedEvent.name],
          ['Expired',   RoleEvents::ExpiredEvent.name],
          ['Interview', RoleEvents::InterviewEvent.name],
          ['Rejected',  RoleEvents::RejectedEvent.name],
          ['Withdrawn', RoleEvents::WithdrawnEvent.name]
        ]
      end

      it 'should return a passing result' do
        expect(command.call(role))
          .to be_a_passing_result
          .with_value(expected)
      end
    end

    describe 'with a role with status "interviewing"' do
      let(:role) { FactoryBot.build(:role, :interviewing) }
      let(:expected) do
        [
          ['Event',     ''],
          ['Closed',    RoleEvents::ClosedEvent.name],
          ['Contacted', RoleEvents::ContactedEvent.name],
          ['Expired',   RoleEvents::ExpiredEvent.name],
          ['Interview', RoleEvents::InterviewEvent.name],
          ['Offered',   RoleEvents::OfferedEvent.name],
          ['Rejected',  RoleEvents::RejectedEvent.name],
          ['Withdrawn', RoleEvents::WithdrawnEvent.name]
        ]
      end

      it 'should return a passing result' do
        expect(command.call(role))
          .to be_a_passing_result
          .with_value(expected)
      end
    end

    describe 'with a role with status "offered"' do
      let(:role) { FactoryBot.build(:role, :offered) }
      let(:expected) do
        [
          ['Event',     ''],
          ['Accepted',  RoleEvents::AcceptedEvent.name],
          ['Closed',    RoleEvents::ClosedEvent.name],
          ['Contacted', RoleEvents::ContactedEvent.name],
          ['Declined',  RoleEvents::DeclinedEvent.name],
          ['Expired',   RoleEvents::ExpiredEvent.name],
          ['Rejected',  RoleEvents::RejectedEvent.name]
        ]
      end

      it 'should return a passing result' do
        expect(command.call(role))
          .to be_a_passing_result
          .with_value(expected)
      end
    end

    describe 'with a role with status "closed"' do
      let(:role) { FactoryBot.build(:role, :accepted) }
      let(:expected) do
        [
          ['Event',     ''],
          ['Closed',    RoleEvents::ClosedEvent.name],
          ['Contacted', RoleEvents::ContactedEvent.name]
        ]
      end

      it 'should return a passing result' do
        expect(command.call(role))
          .to be_a_passing_result
          .with_value(expected)
      end
    end
  end
end
