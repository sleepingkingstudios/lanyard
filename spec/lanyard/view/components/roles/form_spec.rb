# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::Roles::Form, type: :component do
  subject(:form) { described_class.new(**constructor_options) }

  let(:cycles) do
    [
      FactoryBot.create(
        :cycle,
        id:     'ebb9e3bd-823d-469d-8912-ee3abb389a3c',
        year:   '1996',
        season: 'autumn'
      ),
      FactoryBot.create(
        :cycle,
        id:     'ae4e7020-40f5-4787-8eca-96b6ba08f3bf',
        year:   '1999',
        season: 'autumn'
      ),
      FactoryBot.create(
        :cycle,
        id:     '2068aba3-e03c-4c58-9168-9a8fd526762e',
        year:   '2000',
        season: 'autumn'
      )
    ]
  end
  let(:data)   { { 'cycles' => cycles } }
  let(:action) { 'new' }
  let(:resource) do
    Cuprum::Rails::Resource.new(resource_class: Role)
  end
  let(:constructor_options) do
    {
      action:   action,
      data:     data,
      resource: resource
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:action, :data, :resource)
        .and_any_keywords
    end
  end

  describe '#action' do
    include_examples 'should define reader', :action, -> { action }
  end

  describe '#call' do
    let(:rendered) { render_inline(form) }

    describe 'with action: edit' do
      let(:action) { 'edit' }
      let(:data) do
        super().merge(
          'role' => FactoryBot.build(
            :role,
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
            slug:              'indigo-staffing-inc-gym-leader',
            source:            Role::Sources::REFERRAL,
            source_details:    'From misty@example.com',
            time_zone:         'Kanto Standard Time'
          )
        )
      end
      let(:snapshot) do
        <<~HTML
          <form action="/roles/indigo-staffing-inc-gym-leader" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <div class="box">
              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_job_title" class="label">Job Title</label>

                    <div class="control">
                      <input id="role_job_title" name="role[job_title]" class="input" type="text" value="Gym Leader">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_company_name" class="label">Company Name</label>

                    <div class="control">
                      <input id="role_company_name" name="role[company_name]" class="input" type="text" value="Indigo Staffing Inc.">
                    </div>
                  </div>
                </div>
              </div>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_cycle_id" class="label">Cycle</label>

                    <div class="control">
                      <div class="select">
                        <select name="role[cycle_id]" id="role_cycle_id">
                          <option value="ebb9e3bd-823d-469d-8912-ee3abb389a3c">Autumn 1996</option>

                          <option value="ae4e7020-40f5-4787-8eca-96b6ba08f3bf">Autumn 1999</option>

                          <option value="2068aba3-e03c-4c58-9168-9a8fd526762e">Autumn 2000</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_client_name" class="label">Client Name</label>

                    <div class="control">
                      <input id="role_client_name" name="role[client_name]" class="input" type="text" value="Pewter City Civic Society">
                    </div>
                  </div>
                </div>

                <div class="column is-half">
                  <div class="field">
                    <label for="role_slug" class="label">Slug</label>

                    <div class="control">
                      <input id="role_slug" name="role[slug]" class="input" type="text" value="indigo-staffing-inc-gym-leader">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Source</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_source" class="label">Source</label>

                    <div class="control">
                      <div class="select">
                        <select name="role[source]" id="role_source">
                          <option value="email">Email</option>

                          <option value="hired">Hired</option>

                          <option value="linkedin">Linkedin</option>

                          <option value="other">Other</option>

                          <option value="referral" selected="selected">Referral</option>

                          <option value="unknown">Unknown</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column is-three-quarters">
                  <div class="field">
                    <label for="role_source_details" class="label">Source Details</label>

                    <div class="control">
                      <input id="role_source_details" name="role[source_details]" class="input" type="text" value="From misty@example.com">
                    </div>
                  </div>
                </div>
              </div>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_recruiter_name" class="label">Recruiter Name</label>

                    <div class="control">
                      <input id="role_recruiter_name" name="role[recruiter_name]" class="input" type="text" value="Camper Liam">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_agency_name" class="label">Agency Name</label>

                    <div class="control">
                      <input id="role_agency_name" name="role[agency_name]" class="input" type="text" value="Rockin' Jobs">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Contract</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label class="label">Contract Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="contract">

                            Contract
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="contract_to_hire" checked>

                            Contract To Hire
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="full_time">

                            Full Time
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="unknown">

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_contract_duration" class="label">Contract Duration</label>

                    <div class="control">
                      <input id="role_contract_duration" name="role[contract_duration]" class="input" type="text" value="1 year">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Location</h2>

              <div class="columns">
                <div class="column is-half">
                  <div class="field">
                    <label class="label">Location Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="hybrid">

                            Hybrid
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="in_person" checked>

                            In Person
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="remote">

                            Remote
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="unknown">

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_location" class="label">Location</label>

                    <div class="control">
                      <input id="role_location" name="role[location]" class="input" type="text" value="Pewter City">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_time_zone" class="label">Time Zone</label>

                    <div class="control">
                      <input id="role_time_zone" name="role[time_zone]" class="input" type="text" value="Kanto Standard Time">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Compensation</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label class="label">Compensation Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="hourly">

                            Hourly
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="salaried" checked>

                            Salaried
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="unknown">

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_compensation" class="label">Compensation</label>

                    <div class="control">
                      <input id="role_compensation" name="role[compensation]" class="input" type="text" value="Negotiable">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Benefits</h2>

              <div class="columns">
                <div class="column is-one-quarter">
                  <div class="field">
                    <div class="control">
                      <label class="checkbox" name="role[benefits]" for="role_benefits">
                        <input autocomplete="off" name="role[benefits]" type="hidden" value="0">

                        <input name="role[benefits]" type="checkbox" value="1" checked id="role_benefits">

                        Benefits
                      </label>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_benefits_details" class="label">Benefits Details</label>

                    <div class="control">
                      <input id="role_benefits_details" name="role[benefits_details]" class="input" type="text" value="50 percent discount on Poké Balls">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <div class="field">
                <label for="role_industry" class="label">Industry</label>

                <div class="control">
                  <input id="role_industry" name="role[industry]" class="input" type="text" value="Monster Training">
                </div>
              </div>

              <div class="field">
                <label for="role_notes" class="label">Notes</label>

                <div class="control">
                  <textarea class="textarea" name="role[notes]" id="role_notes">Must train Rock-type Pokémon!</textarea>
                </div>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Role</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/roles/indigo-staffing-inc-gym-leader" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with action: new' do
      let(:action) { 'new' }
      let(:data)   { nil }
      let(:snapshot) do
        <<~HTML
          <form action="/roles" accept-charset="UTF-8" method="post">
            <div class="box">
              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_job_title" class="label">Job Title</label>

                    <div class="control">
                      <input id="role_job_title" name="role[job_title]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_company_name" class="label">Company Name</label>

                    <div class="control">
                      <input id="role_company_name" name="role[company_name]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>
              </div>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_cycle_id" class="label">Cycle</label>

                    <div class="control">
                      <div class="select">
                        <select name="role[cycle_id]" id="role_cycle_id">
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_client_name" class="label">Client Name</label>

                    <div class="control">
                      <input id="role_client_name" name="role[client_name]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>

                <div class="column is-half">
                  <div class="field">
                    <label for="role_slug" class="label">Slug</label>

                    <div class="control">
                      <input id="role_slug" name="role[slug]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Source</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_source" class="label">Source</label>

                    <div class="control">
                      <div class="select">
                        <select name="role[source]" id="role_source">
                          <option value="email">Email</option>

                          <option value="hired">Hired</option>

                          <option value="linkedin">Linkedin</option>

                          <option value="other">Other</option>

                          <option value="referral">Referral</option>

                          <option value="unknown" selected="selected">Unknown</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column is-three-quarters">
                  <div class="field">
                    <label for="role_source_details" class="label">Source Details</label>

                    <div class="control">
                      <input id="role_source_details" name="role[source_details]" class="input" type="text">
                    </div>
                  </div>
                </div>
              </div>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label for="role_recruiter_name" class="label">Recruiter Name</label>

                    <div class="control">
                      <input id="role_recruiter_name" name="role[recruiter_name]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_agency_name" class="label">Agency Name</label>

                    <div class="control">
                      <input id="role_agency_name" name="role[agency_name]" class="input" type="text" value="">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Contract</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label class="label">Contract Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="contract">

                            Contract
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="contract_to_hire">

                            Contract To Hire
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="full_time">

                            Full Time
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[contract_type]">
                            <input name="role[contract_type]" type="radio" value="unknown" checked>

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_contract_duration" class="label">Contract Duration</label>

                    <div class="control">
                      <input id="role_contract_duration" name="role[contract_duration]" class="input" type="text">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Location</h2>

              <div class="columns">
                <div class="column is-half">
                  <div class="field">
                    <label class="label">Location Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="hybrid">

                            Hybrid
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="in_person">

                            In Person
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="remote">

                            Remote
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[location_type]">
                            <input name="role[location_type]" type="radio" value="unknown" checked>

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_location" class="label">Location</label>

                    <div class="control">
                      <input id="role_location" name="role[location]" class="input" type="text">
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_time_zone" class="label">Time Zone</label>

                    <div class="control">
                      <input id="role_time_zone" name="role[time_zone]" class="input" type="text">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Compensation</h2>

              <div class="columns">
                <div class="column">
                  <div class="field">
                    <label class="label">Compensation Type</label>

                    <div class="control">
                      <div class="columns">
                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="hourly">

                            Hourly
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="salaried">

                            Salaried
                          </label>
                        </div>

                        <div class="column">
                          <label class="radio" name="role[compensation_type]">
                            <input name="role[compensation_type]" type="radio" value="unknown" checked>

                            Unknown
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_compensation" class="label">Compensation</label>

                    <div class="control">
                      <input id="role_compensation" name="role[compensation]" class="input" type="text">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <h2 class="title is-4">Benefits</h2>

              <div class="columns">
                <div class="column is-one-quarter">
                  <div class="field">
                    <div class="control">
                      <label class="checkbox" name="role[benefits]" for="role_benefits">
                        <input autocomplete="off" name="role[benefits]" type="hidden" value="0">

                        <input name="role[benefits]" type="checkbox" value="1" id="role_benefits">

                        Benefits
                      </label>
                    </div>
                  </div>
                </div>

                <div class="column">
                  <div class="field">
                    <label for="role_benefits_details" class="label">Benefits Details</label>

                    <div class="control">
                      <input id="role_benefits_details" name="role[benefits_details]" class="input" type="text">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="box">
              <div class="field">
                <label for="role_industry" class="label">Industry</label>

                <div class="control">
                  <input id="role_industry" name="role[industry]" class="input" type="text">
                </div>
              </div>

              <div class="field">
                <label for="role_notes" class="label">Notes</label>

                <div class="control">
                  <textarea class="textarea" name="role[notes]" id="role_notes"></textarea>
                </div>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Role</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/roles" target="_self">
                      Cancel
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
