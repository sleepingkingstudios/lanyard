# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: 'RoleEvent' do
    transient do
      event_name { 'event' }
    end

    role        { nil }
    event_date  { Time.current.to_date }
    event_index { role&.persisted? ? RoleEvent.where(role: role).count : 0 }

    slug { "#{event_date.strftime('%Y-%m-%d')}-#{event_index}-#{event_name}" }

    trait(:with_role) do
      role { FactoryBot.create(:role, :with_cycle) }
    end
  end

  # :nocov:
  factory :accepted_event, parent: :event, class: 'RoleEvents::AcceptedEvent' do
    transient do
      event_name { 'accepted' }
    end
  end

  factory :applied_event, parent: :event, class: 'RoleEvents::AppliedEvent' do
    transient do
      event_name { 'applied' }
    end
  end

  factory :closed_event, parent: :event, class: 'RoleEvents::ClosedEvent' do
    transient do
      event_name { 'closed' }
    end
  end

  factory :contacted_event,
    parent: :event,
    class:  'RoleEvents::ContactedEvent' \
  do
    transient do
      event_name { 'contacted' }
    end
  end

  factory :declined_event, parent: :event, class: 'RoleEvents::DeclinedEvent' do
    transient do
      event_name { 'declined' }
    end
  end

  factory :expired_event, parent: :event, class: 'RoleEvents::ExpiredEvent' do
    transient do
      event_name { 'expired' }
    end
  end

  factory :interview_event,
    parent: :event,
    class:  'RoleEvents::InterviewEvent' \
  do
    transient do
      event_name { 'interview' }
    end
  end

  factory :offered_event, parent: :event, class: 'RoleEvents::OfferedEvent' do
    transient do
      event_name { 'offered' }
    end
  end

  factory :pitched_event, parent: :event, class: 'RoleEvents::PitchedEvent' do
    transient do
      event_name { 'pitched' }
    end
  end

  factory :rejected_event, parent: :event, class: 'RoleEvents::RejectedEvent' do
    transient do
      event_name { 'rejected' }
    end
  end

  factory :withdrawn_event,
    parent: :event,
    class:  'RoleEvents::WithdrawnEvent' \
  do
    transient do
      event_name { 'withdrawn' }
    end
  end
  # :nocov:
end
