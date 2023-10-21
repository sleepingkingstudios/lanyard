# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::Cycles::Form, type: :component do
  subject(:form) { described_class.new(**constructor_options) }

  let(:data)   { {} }
  let(:action) { 'new' }
  let(:resource) do
    Cuprum::Rails::Resource.new(resource_class: Cycle)
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
        {
          'cycle' => FactoryBot.build(:cycle, year: '1999', season: 'winter')
        }
      end
      let(:snapshot) do
        <<~HTML
          <form action="/cycles/winter-1999" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <input name="name" class="input" type="hidden" value="">

            <input name="slug" class="input" type="hidden" value="">

            <div class="columns">
              <div class="column">
                <div class="field">
                  <label for="cycle_season_index" class="label">Season</label>

                  <div class="control">
                    <div class="select">
                      <select name="cycle[season_index]" id="cycle_season_index">
                        <option value=""> </option>

                        <option value="0" selected="selected">Winter</option>

                        <option value="1">Spring</option>

                        <option value="2">Summer</option>

                        <option value="3">Autumn</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <label for="cycle_year" class="label">Year</label>

                  <div class="control">
                    <input id="cycle_year" name="cycle[year]" class="input" type="text" value="1999">
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <div class="control">
                    <label class="checkbox" name="cycle[active]" for="cycle_active">
                      <input autocomplete="off" name="cycle[active]" type="hidden" value="0">

                      <input name="cycle[active]" type="checkbox" value="1" id="cycle_active">

                      Active
                    </label>
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <div class="control">
                    <label class="checkbox" name="cycle[ui_eligible]" for="cycle_ui_eligible">
                      <input autocomplete="off" name="cycle[ui_eligible]" type="hidden" value="0">

                      <input name="cycle[ui_eligible]" type="checkbox" value="1" id="cycle_ui_eligible">

                      UI Eligible
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Cycle</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/cycles/winter-1999" target="_self">
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
          <form action="/cycles" accept-charset="UTF-8" method="post">
            <input name="name" class="input" type="hidden" value="">

            <input name="slug" class="input" type="hidden" value="">

            <div class="columns">
              <div class="column">
                <div class="field">
                  <label for="cycle_season_index" class="label">Season</label>

                  <div class="control">
                    <div class="select">
                      <select name="cycle[season_index]" id="cycle_season_index">
                        <option value=""> </option>

                        <option value="0">Winter</option>

                        <option value="1">Spring</option>

                        <option value="2">Summer</option>

                        <option value="3">Autumn</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <label for="cycle_year" class="label">Year</label>

                  <div class="control">
                    <input id="cycle_year" name="cycle[year]" class="input" type="text" value="">
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <div class="control">
                    <label class="checkbox" name="cycle[active]" for="cycle_active">
                      <input autocomplete="off" name="cycle[active]" type="hidden" value="0">

                      <input name="cycle[active]" type="checkbox" value="1" id="cycle_active">

                      Active
                    </label>
                  </div>
                </div>
              </div>

              <div class="column">
                <div class="field">
                  <div class="control">
                    <label class="checkbox" name="cycle[ui_eligible]" for="cycle_ui_eligible">
                      <input autocomplete="off" name="cycle[ui_eligible]" type="hidden" value="0">

                      <input name="cycle[ui_eligible]" type="checkbox" value="1" id="cycle_ui_eligible">

                      UI Eligible
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Cycle</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/cycles" target="_self">
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
