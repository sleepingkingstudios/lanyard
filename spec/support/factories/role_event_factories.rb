# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: 'RoleEvent' do
    transient do
      sequence(:event_index) { |index| index }
    end

    event_date { Time.current.to_date }

    slug { "event-#{event_index}" }

    trait(:with_role) do
      role { FactoryBot.create(:role, :with_cycle) }
    end
  end
end
