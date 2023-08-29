# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::JobSearches::Block, type: :component \
do
  subject(:block) { described_class.new(data: data) }

  let(:data) do
    FactoryBot.build(
      :job_search,
      start_date: Date.new(1982, 7)
    )
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(block) }
    let(:snapshot) do
      <<~HTML
        <div class="block content">
          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Start Date
            </div>

            <div class="column">
              1982-07-01
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              End Date
            </div>

            <div class="column">
              —
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a job search with an end date' do
      let(:data) do
        FactoryBot.build(
          :job_search,
          start_date: Date.new(1982, 7, 1),
          end_date:   Date.new(1982, 8, 31)
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Start Date
              </div>

              <div class="column">
                1982-07-01
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                End Date
              </div>

              <div class="column">
                1982-08-31
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end
end
