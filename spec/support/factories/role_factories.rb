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
  end
end
