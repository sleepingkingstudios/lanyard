# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::RoleEvents::ParseString do
  subject(:command) { described_class.new(year: year) }

  let(:year) { 1996 }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:year)
    end
  end

  describe '#call' do
    let(:raw_value)     { '' }
    let(:error_message) { nil }
    let(:expected_error) do
      Lanyard::Import::Errors::ParseError.new(
        entity_class: RoleEvent,
        raw_value:    raw_value,
        message:      error_message
      )
    end

    it { expect(command).to be_callable.with(1).argument }

    describe 'with an empty string' do
      let(:error_message) { 'wrong number of words' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with a malformed string' do
      let(:raw_value)     { 'Maybe Applied Jan 1' }
      let(:error_message) { 'wrong number of words' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an invalid event type' do
      let(:raw_value)     { 'Exploded Jan 1' }
      let(:error_message) { 'invalid event type "Exploded"' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an invalid event month' do
      let(:raw_value)     { 'Applied ??? 1' }
      let(:error_message) { 'invalid month "???"' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an invalid event day' do
      let(:raw_value)     { 'Applied Jan 0' }
      let(:error_message) { 'invalid day "0"' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with an invalid event date' do
      let(:raw_value)     { 'Applied Feb 30' }
      let(:error_message) { 'invalid date 1996, 2, 30' }

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with a valid event with type "Applied"' do
      let(:raw_value)  { 'Applied Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::AppliedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Contacted"' do
      let(:raw_value)  { 'Contacted Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::ContactedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Closed"' do
      let(:raw_value)  { 'Closed Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::ClosedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Interview"' do
      let(:raw_value)  { 'Interview Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::InterviewEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Offered"' do
      let(:raw_value)  { 'Offered Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::OfferedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Pitched"' do
      let(:raw_value)  { 'Pitched Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::PitchedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Rejected"' do
      let(:raw_value)  { 'Rejected Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::RejectedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a valid event with type "Submitted"' do
      let(:raw_value)  { 'Submitted Jan 1' }
      let(:event_date) { Date.new(1996, 1, 1) }
      let(:expected_value) do
        {
          'event_date' => event_date,
          'type'       => RoleEvents::PitchedEvent.name
        }
      end

      it 'should return a failing result' do
        expect(command.call(raw_value))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].each.with_index \
    do |month, month_index|
      describe "with a valid event in #{month}" do
        let(:raw_value)  { "Applied #{month} 1" }
        let(:event_date) { Date.new(1996, 1 + month_index, 1) }
        let(:expected_value) do
          {
            'event_date' => event_date,
            'type'       => RoleEvents::AppliedEvent.name
          }
        end

        it 'should return a failing result' do
          expect(command.call(raw_value))
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end
    end
  end
end
