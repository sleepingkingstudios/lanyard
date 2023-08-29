# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::JobSearches::Form, type: :component do
  subject(:form) { described_class.new(**constructor_options) }

  let(:data) do
    {
      'job_search' => FactoryBot.build(
        :job_search,
        start_date: Date.new(1982, 7)
      )
    }
  end
  let(:action) { 'new' }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      base_path:      'job-searches',
      resource_class: JobSearch,
      resource_name:  'job_searches'
    )
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
      let(:snapshot) do
        <<~HTML
          <form action="job-searches/1982-07" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <div class="field">
              <label for="job_search_start_date" class="label">Start Date</label>

              <div class="control">
                <input id="job_search_start_date" name="job_search[start_date]" class="input" type="text" value="1982-07-01">
              </div>
            </div>

            <div class="field">
              <label for="job_search_end_date" class="label">End Date</label>

              <div class="control">
                <input id="job_search_end_date" name="job_search[end_date]" class="input" type="text">
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Job Search</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="job-searches/1982-07" target="_self">
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
      let(:data)   { nil }
      let(:action) { 'new' }
      let(:snapshot) do
        <<~HTML
          <form action="job-searches" accept-charset="UTF-8" method="post">
            <div class="field">
              <label for="job_search_start_date" class="label">Start Date</label>

              <div class="control">
                <input id="job_search_start_date" name="job_search[start_date]" class="input" type="text">
              </div>
            </div>

            <div class="field">
              <label for="job_search_end_date" class="label">End Date</label>

              <div class="control">
                <input id="job_search_end_date" name="job_search[end_date]" class="input" type="text">
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Job Search</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="job-searches" target="_self">
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
