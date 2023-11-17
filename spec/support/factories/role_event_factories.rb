# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: 'RoleEvent' do
    transient do
      event_name { 'event' }
    end

    role        { nil }
    event_date  { Time.current.to_date }
    event_index { role&.persisted? ? RoleEvent.where(role: role).count : nil }

    slug { "#{event_date.iso8601}-#{event_index}-#{event_name}" }

    trait(:with_role) do
      role { FactoryBot.create(:role, :with_cycle) }
    end
  end

  factory :applied_event, parent: :event, class: 'RoleEvents::AppliedEvent' do
    transient do
      event_name { 'applied' }
    end
  end
end
