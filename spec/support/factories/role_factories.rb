# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: 'Role' do
    transient do
      sequence(:role_index) { |index| index }
    end

    slug          { "role-#{role_index}" }
    source        { Role::Sources::OTHER }
    last_event_at { Time.current }

    trait(:with_cycle) do
      cycle { FactoryBot.create(:cycle) }
    end

    trait(:with_events) do
      after(:create) do |role|
        create(
          :contacted_event,
          role:        role,
          event_date:  (role.applied_at || Time.current).to_date - 1.day,
          event_index: 0
        )

        create( # rubocop:disable Style/MultilineIfModifier
          :applied_event,
          role:        role,
          event_date:  role.applied_at.to_date,
          event_index: 1
        ) if role.applied_at.present?

        create( # rubocop:disable Style/MultilineIfModifier
          :interview_event,
          role:        role,
          event_date:  role.interviewing_at.to_date,
          event_index: 2
        ) if role.interviewing_at.present?

        create( # rubocop:disable Style/MultilineIfModifier
          :offered_event,
          role:        role,
          event_date:  role.offered_at.to_date,
          event_index: 3
        ) if role.offered_at.present?
      end
    end

    trait(:new) do
      status { Role::Statuses::NEW }
    end

    trait(:applied) do
      status     { Role::Statuses::APPLIED }
      applied_at { 1.day.ago }
    end

    trait(:interviewing) do
      status          { Role::Statuses::INTERVIEWING }
      applied_at      { 2.days.ago }
      interviewing_at { 1.day.ago }
    end

    trait(:offered) do
      status          { Role::Statuses::OFFERED }
      applied_at      { 3.days.ago }
      interviewing_at { 2.days.ago }
      offered_at      { 1.day.ago }
    end

    trait(:closed) do
      status          { Role::Statuses::CLOSED }
      applied_at      { 4.days.ago }
      interviewing_at { 3.days.ago }
      offered_at      { 2.days.ago }
      closed_at       { 1.day.ago }
    end

    trait(:accepted) do
      closed
    end
  end
end
