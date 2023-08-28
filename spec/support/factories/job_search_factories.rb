# frozen_string_literal: true

FactoryBot.define do
  factory :job_search, class: 'JobSearch' do
    transient do
      sequence(:start_date_year) { |index| 1980 + index }

      start_date_month { Random.rand(1..12) }
    end

    start_date { Date.new(start_date_year, start_date_month) }
    slug       { start_date.strftime('%Y-%m') }
  end
end
