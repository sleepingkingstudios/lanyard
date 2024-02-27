# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Migrations::SetRoleLastEventAt do
  let(:cycle) { FactoryBot.build(:cycle) }
  let(:role_without_events) do
    FactoryBot.build(
      :role,
      cycle:         cycle,
      created_at:    2.weeks.ago,
      last_event_at: nil
    )
  end
  let(:role_with_events) do
    FactoryBot.build(
      :role,
      cycle:         cycle,
      created_at:    1.week.ago,
      last_event_at: nil
    )
  end
  let(:roles) do
    [
      role_without_events,
      role_with_events
    ]
  end
  let(:role_events) do
    [
      FactoryBot.build(
        :applied_event,
        role:        role_with_events,
        event_date:  1.week.ago,
        event_index: 0
      ),
      FactoryBot.build(
        :interview_event,
        role:        role_with_events,
        event_date:  5.days.ago,
        event_index: 1
      ),
      FactoryBot.build(
        :offered_event,
        role:        role_with_events,
        event_date:  3.days.ago,
        event_index: 2
      ),
      FactoryBot.build(
        :accepted_event,
        role:        role_with_events,
        event_date:  1.day.ago,
        event_index: 3
      )
    ]
  end

  before(:example) do
    cycle.save!
    roles.each(&:save!)
    role_events.each(&:save!)
  end

  describe '.down' do
    let(:expected) { roles.map(&:attributes) }

    it 'should not change the data' do
      described_class.down

      expect(Role.order(:created_at).map(&:attributes)).to be == expected
    end

    context 'when the data is already defined' do
      let(:role_without_events) do
        FactoryBot.build(
          :role,
          cycle:         cycle,
          created_at:    2.weeks.ago,
          last_event_at: 2.weeks.ago
        )
      end
      let(:role_with_events) do
        FactoryBot.build(
          :role,
          cycle:         cycle,
          created_at:    1.week.ago,
          last_event_at: 1.week.ago
        )
      end
      let(:expected) do
        roles.map { |role| role.attributes.merge('last_event_at' => nil) }
      end

      it 'should clear the #last_event_at column' do
        described_class.down

        expect(Role.order(:created_at).map(&:attributes)).to deep_match expected
      end
    end
  end

  describe '.up' do
    let(:expected) do
      [
        role_without_events.attributes.merge(
          'last_event_at' => role_without_events.created_at
        ),
        role_with_events.attributes.merge(
          'last_event_at' => role_events.last.event_date.beginning_of_day
        )
      ]
    end

    it 'should set the #last_event_at column' do
      described_class.up

      expect(Role.order(:created_at).map(&:attributes)).to deep_match expected
    end

    context 'when the data is already defined' do
      let(:role_without_events) do
        FactoryBot.build(
          :role,
          cycle:         cycle,
          created_at:    2.weeks.ago,
          last_event_at: 2.weeks.ago
        )
      end
      let(:role_with_events) do
        FactoryBot.build(
          :role,
          cycle:         cycle,
          created_at:    1.week.ago,
          last_event_at: 1.week.ago
        )
      end
      let(:expected) { roles.map(&:attributes) }

      it 'should not change the data' do
        described_class.up

        expect(Role.order(:created_at).map(&:attributes)).to be == expected
      end
    end
  end
end
