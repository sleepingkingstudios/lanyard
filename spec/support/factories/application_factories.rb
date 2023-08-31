# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: 'Application' do
    transient do
      sequence(:application_index) { |index| index }
    end

    slug   { "application-#{application_index}" }
    source { Application::Sources::OTHER }

    trait(:with_job_search) do
      job_search { FactoryBot.create(:job_search) }
    end
  end
end
