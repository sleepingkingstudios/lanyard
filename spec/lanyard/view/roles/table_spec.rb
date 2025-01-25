# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Roles::Table, type: :component do
  subject(:table) { described_class.new(**constructor_options) }

  shared_context 'with data' do
    let(:cycle) do
      FactoryBot.build(:cycle, year: '1996', season: 'winter')
    end
    let(:data) do
      [
        FactoryBot.build(
          :role,
          cycle:         cycle,
          slug:          'pokemon-trainer',
          job_title:     'Pokémon Trainer',
          company_name:  'Indigo League',
          contract_type: Role::ContractTypes::FULL_TIME,
          location_type: Role::LocationTypes::REMOTE,
          status:        Role::Statuses::NEW,
          last_event_at: '2003-03-10'
        ),
        FactoryBot.build(
          :role,
          cycle:         cycle,
          slug:          'gym-leader',
          job_title:     'Gym Leader',
          company_name:  'Pewter City Civil Society',
          contract_type: Role::ContractTypes::CONTRACT,
          location_type: Role::LocationTypes::IN_PERSON,
          status:        Role::Statuses::APPLIED,
          last_event_at: '2001-11-02'
        ),
        FactoryBot.build(
          :role,
          cycle:         cycle,
          slug:          'gate-guard',
          job_title:     'Gate Guard',
          company_name:  'Indigo Plateau Constabulary',
          contract_type: Role::ContractTypes::CONTRACT_TO_HIRE,
          location_type: Role::LocationTypes::IN_PERSON,
          status:        Role::Statuses::INTERVIEWING,
          last_event_at: '2000-10-15'
        ),
        FactoryBot.build(
          :role,
          cycle:         cycle,
          slug:          'dragon-tamer',
          job_title:     'Dragon Tamer',
          company_name:  'Blackthorn City Gym',
          contract_type: Role::ContractTypes::CONTRACT,
          location_type: Role::LocationTypes::IN_PERSON,
          status:        Role::Statuses::OFFERED,
          last_event_at: '1999-10-19'
        ),
        FactoryBot.build(
          :role,
          cycle:         cycle,
          slug:          'research-assistant',
          job_title:     'Research Assistant',
          agency_name:   'Viridian Gym Consultancy',
          contract_type: Role::ContractTypes::CONTRACT_TO_HIRE,
          location_type: Role::LocationTypes::HYBRID,
          status:        Role::Statuses::CLOSED,
          last_event_at: '1998-09-28'
        )
      ]
    end
  end

  let(:data)     { [] }
  let(:resource) { Cuprum::Rails::Resource.new(name: 'roles') }
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
        .and_any_keywords
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
              <th>Job Title</th>

              <th>Company</th>

              <th>Contract</th>

              <th>Remote</th>

              <th>Status</th>

              <th>Cycle</th>

              <th>Updated</th>

              <th> </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="8">There are no roles matching the criteria.</td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    before(:example) do
      allow(Lanyard::View::Roles::TableActions)
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
                <th>Job Title</th>

                <th>Company</th>

                <th>Contract</th>

                <th>Remote</th>

                <th>Status</th>

                <th>Cycle</th>

                <th>Updated</th>

                <th> </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  <a class="has-text-link" href="/roles/pokemon-trainer" target="_self">
                    Pokémon Trainer
                  </a>
                </td>

                <td>
                  Indigo League
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-success">
                    <i class="fas fa-check"></i>
                  </span>
                </td>

                <td>
                  <span class="has-text-black">New</span>
                </td>

                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  2003-03-10
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/roles/gym-leader" target="_self">
                    Gym Leader
                  </a>
                </td>

                <td>
                  Pewter City Civil Society
                </td>

                <td>
                  <span class="icon has-text-success">
                    <i class="fas fa-check"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="has-text-info">Applied</span>
                </td>

                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  2001-11-02
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/roles/gate-guard" target="_self">
                    Gate Guard
                  </a>
                </td>

                <td>
                  Indigo Plateau Constabulary
                </td>

                <td>
                  <span class="icon has-text-success">
                    <i class="fas fa-check"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="has-text-success">Interviewing</span>
                </td>

                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  2000-10-15
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/roles/dragon-tamer" target="_self">
                    Dragon Tamer
                  </a>
                </td>

                <td>
                  Blackthorn City Gym
                </td>

                <td>
                  <span class="icon has-text-success">
                    <i class="fas fa-check"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="has-text-success">Offered</span>
                </td>

                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  1999-10-19
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/roles/research-assistant" target="_self">
                    Research Assistant
                  </a>
                </td>

                <td>
                  Viridian Gym Consultancy
                </td>

                <td>
                  <span class="icon has-text-success">
                    <i class="fas fa-check"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="has-text-danger">Closed</span>
                </td>

                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  1998-09-28
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

    wrap_context 'with data' do
      it { expect(table.data).to be == data }
    end
  end
end
