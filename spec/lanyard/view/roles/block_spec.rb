# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Roles::Block, type: :component do
  subject(:block) { described_class.new(data: data, routes: routes) }

  let(:cycle) { FactoryBot.build(:cycle, year: '1996', season: 'winter') }
  let(:attributes) do
    {
      cycle: cycle,
      slug:  'indigo-staffing-inc-gym-leader'
    }
  end
  let(:data) do
    FactoryBot.build(:role, **attributes)
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes
      .new(base_path: '/path/to/roles')
      .with_wildcards({ 'id' => attributes[:slug] })
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data, :routes)
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
              Job Title
            </div>

            <div class="column">
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Company Name
            </div>

            <div class="column">
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Client Name
            </div>

            <div class="column">
              (none)
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Slug
            </div>

            <div class="column">
              indigo-staffing-inc-gym-leader
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Cycle
            </div>

            <div class="column">
              <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                Winter 1996
              </a>
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Status
            </div>

            <div class="column">
              <span class="has-text-black">New</span>
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Contract
            </div>

            <div class="column">
              Unknown
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Location
            </div>

            <div class="column">
              Unknown
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Industry
            </div>

            <div class="column">
              Unknown
            </div>
          </div>
        </div>

        <h3 class="title is-4">Source</h3>

        <div class="block content">
          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Source
            </div>

            <div class="column">
              Other
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Source Details
            </div>

            <div class="column">
            </div>
          </div>
        </div>

        <h3 class="title is-4">Compensation</h3>

        <div class="block content">
          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Compensation
            </div>

            <div class="column">
              Unknown
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Benefits
            </div>

            <div class="column">
              No
            </div>
          </div>
        </div>

        <h3 class="title is-4">Events</h3>

        <p class="block">
          <a class="has-text-link" href="/path/to/roles/indigo-staffing-inc-gym-leader/events" target="_self">
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-right-long"></i>
              </span>

              <span>Go to Events</span>
            </span>
          </a>
        </p>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a role with data' do
      let(:attributes) do
        super().merge(
          agency_name:       "Rockin' Jobs",
          benefits:          true,
          benefits_details:  '50 percent discount on Poké Balls',
          client_name:       'Pewter City Civic Society',
          company_name:      'Indigo Staffing Inc.',
          compensation:      'Negotiable',
          compensation_type: Role::CompensationTypes::SALARIED,
          contract_duration: '1 year',
          contract_type:     Role::ContractTypes::CONTRACT_TO_HIRE,
          industry:          'Monster Training',
          job_title:         'Gym Leader',
          location:          'Pewter City',
          location_type:     Role::LocationTypes::IN_PERSON,
          notes:             'Must train Rock-type Pokémon!',
          recruiter_name:    'Camper Liam',
          source:            Role::Sources::REFERRAL,
          source_details:    'From misty@example.com',
          time_zone:         'Kanto Standard Time'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Job Title
              </div>

              <div class="column">
                Gym Leader
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Company Name
              </div>

              <div class="column">
                Indigo Staffing Inc.
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Client Name
              </div>

              <div class="column">
                Pewter City Civic Society
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Slug
              </div>

              <div class="column">
                indigo-staffing-inc-gym-leader
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Cycle
              </div>

              <div class="column">
                <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                  Winter 1996
                </a>
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Status
              </div>

              <div class="column">
                <span class="has-text-black">New</span>
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Contract
              </div>

              <div class="column">
                Contract To Hire - 1 year
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Location
              </div>

              <div class="column">
                In Person - Pewter City (Kanto Standard Time)
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Industry
              </div>

              <div class="column">
                Monster Training
              </div>
            </div>
          </div>

          <h3 class="title is-4">Source</h3>

          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Source
              </div>

              <div class="column">
                Referral
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Source Details
              </div>

              <div class="column">
                From misty@example.com
              </div>
            </div>
          </div>

          <h4 class="title is-5">Recruiter</h4>

          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Recruiter Name
              </div>

              <div class="column">
                Camper Liam
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Agency Name
              </div>

              <div class="column">
                Rockin' Jobs
              </div>
            </div>
          </div>

          <h3 class="title is-4">Compensation</h3>

          <div class="block content">
            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Compensation
              </div>

              <div class="column">
                Salaried - Negotiable
              </div>
            </div>

            <div class="columns mb-0">
              <div class="column is-2 has-text-weight-semibold mb-1">
                Benefits
              </div>

              <div class="column">
                Yes - 50 percent discount on Poké Balls
              </div>
            </div>
          </div>

          <h3 class="title is-4">Events</h3>

          <p class="block">
            <a class="has-text-link" href="/path/to/roles/indigo-staffing-inc-gym-leader/events" target="_self">
              <span class="icon-text">
                <span class="icon">
                  <i class="fas fa-right-long"></i>
                </span>

                <span>Go to Events</span>
              </span>
            </a>
          </p>

          <h3 class="title is-4">Notes</h3>

          <div class="content">
            Must train Rock-type Pokémon!
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
