# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: 'Role' do
    transient do
      sequence(:role_index) { |index| index }
    end

    slug   { "role-#{role_index}" }
    source { Role::Sources::OTHER }

    trait(:with_cycle) do
      cycle { FactoryBot.create(:cycle) }
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

    trait(:accepted) do
      status          { Role::Statuses::CLOSED }
      applied_at      { 4.days.ago }
      interviewing_at { 3.days.ago }
      offered_at      { 2.days.ago }
      closed_at       { 1.day.ago }
    end
  end
end
