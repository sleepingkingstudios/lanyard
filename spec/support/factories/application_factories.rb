# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: 'Application' do
    transient do
      sequence(:application_index) { |index| index }
    end

    slug   { "#{application_index}-0" }
    source { Application::Sources::OTHER }
  end
end
