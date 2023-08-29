# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::JobSearches::Table, type: :component \
do
  subject(:table) { described_class.new(**constructor_options) }

  shared_context 'with data' do
    let(:start_dates) do
      [
        Date.new(1982, 7),
        Date.new(1992, 7),
        Date.new(2002, 7)
      ]
    end
    let(:data) do
      job_searches = start_dates.map do |start_date|
        FactoryBot.build(:job_search, start_date: start_date)
      end

      job_searches.first.end_date = Date.new(1982, 8, 31)

      job_searches
    end
  end

  let(:data) { [] }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      base_path:     '/job-searches',
      resource_name: 'job_searches'
    )
  end
  let(:constructor_options) do
    {
      data:     data,
      resource: resource
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :resource)
    end
  end

  describe '#call' do
    let(:mock_actions) do
      Librum::Core::View::Components::IdentityComponent.new('[actions]')
    end
    let(:rendered) { render_inline(table) }
    let(:snapshot) do
      <<~HTML
        <table class="table is-striped">
          <thead>
            <tr>
              <th>Start Date</th>

              <th>End Date</th>

              <th> </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="3">There are no job searches matching the criteria.</td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    before(:example) do
      allow(Librum::Core::View::Components::Resources::TableActions)
        .to receive(:new)
        .and_return(mock_actions)
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    wrap_context 'with data' do
      let(:snapshot) do
        <<~HTML
          <table class="table is-striped">
            <thead>
              <tr>
                <th>Start Date</th>

                <th>End Date</th>

                <th> </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  <a class="has-text-link" href="/job-searches/1982-07" target="_self">
                    1982-07
                  </a>
                </td>

                <td>
                  1982-08-31
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/job-searches/1992-07" target="_self">
                    1992-07
                  </a>
                </td>

                <td>
                  —
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/job-searches/2002-07" target="_self">
                    2002-07
                  </a>
                </td>

                <td>
                  —
                </td>

                <td>
                  [actions]
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end
end
