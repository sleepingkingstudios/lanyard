# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::RoleEvents::Form, type: :component do
  subject(:form) { described_class.new(**constructor_options) }

  let(:data)           { {} }
  let(:action)         { 'new' }
  let(:roles_resource) { Cuprum::Rails::Resource.new(name: 'roles') }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      actions: %w[index new create show edit update],
      name:    'events',
      parent:  roles_resource
    )
  end
  let(:routes) do
    resource.routes.with_wildcards({ 'role_id' => 'pokemon-trainer' })
  end
  let(:constructor_options) do
    {
      action:   action,
      data:     data,
      resource: resource,
      routes:   routes
    }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:action, :data, :resource, :routes)
        .and_any_keywords
    end
  end

  describe '#action' do
    include_examples 'should define reader', :action, -> { action }
  end

  describe '#call' do
    let(:event_types) do
      {
        'Event'   => '',
        'Applied' => 'RoleEvents::AppliedEvent',
        'Custom'  => 'CustomEvent'
      }
    end
    let(:role) do
      FactoryBot.build(
        :role,
        id:   '00000000-0000-0000-0000-000000000000',
        slug: 'pokemon-trainer'
      )
    end
    let(:rendered) { render_inline(form) }

    before(:example) do
      allow(RoleEvent).to receive(:event_types).and_return(event_types)
    end

    describe 'with action: edit' do
      let(:action) { 'edit' }
      let(:data) do
        super().merge(
          'role'  => role,
          'event' => FactoryBot.build(
            :applied_event,
            role:       role,
            slug:       '1996-09-29-applied',
            event_date: Date.new(1996, 6, 29),
            summary:    'Blew dust from cartridge',
            notes:      'Something something, the very best.'
          )
        )
      end
      let(:snapshot) do
        <<~HTML
          <form action="/roles/pokemon-trainer/events/1996-09-29-applied" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <input name="event[role_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000000">

            <div class="field">
              <label for="event_type" class="label">Type</label>

              <div class="control">
                <div class="select">
                  <select name="event[type]" disabled="disabled" id="event_type">
                    <option value="">Event</option>

                    <option value="RoleEvents::AppliedEvent" selected="selected">Applied</option>

                    <option value="CustomEvent">Custom</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="field">
              <label for="event_event_date" class="label">Event Date</label>

              <div class="control">
                <input id="event_event_date" disabled name="event[event_date]" class="input" type="text" value="1996-06-29">
              </div>
            </div>

            <div class="field">
              <label for="event_summary" class="label">Summary</label>

              <div class="control">
                <input id="event_summary" name="event[summary]" class="input" placeholder="Applied directly for the role" type="text" value="Blew dust from cartridge">
              </div>
            </div>

            <div class="field">
              <label for="event_notes" class="label">Notes</label>

              <div class="control">
                <textarea class="textarea" name="event[notes]" id="event_notes">Something something, the very best.</textarea>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Update Event</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/roles/pokemon-trainer/events/1996-09-29-applied" target="_self">
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
      let(:data)   { super().merge('role' => role, 'event' => RoleEvent.new) }
      let(:snapshot) do
        <<~HTML
          <form action="/roles/pokemon-trainer/events" accept-charset="UTF-8" method="post">
            <input name="event[role_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000000">

            <div class="field">
              <label for="event_type" class="label">Type</label>

              <div class="control">
                <div class="select">
                  <select name="event[type]" id="event_type">
                    <option value="">Event</option>

                    <option value="RoleEvents::AppliedEvent">Applied</option>

                    <option value="CustomEvent">Custom</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="field">
              <label for="event_event_date" class="label">Event Date</label>

              <div class="control">
                <input id="event_event_date" name="event[event_date]" class="input" type="text">
              </div>
            </div>

            <div class="field">
              <label for="event_summary" class="label">Summary</label>

              <div class="control">
                <input id="event_summary" name="event[summary]" class="input" placeholder="Generic role event" type="text" value="">
              </div>
            </div>

            <div class="field">
              <label for="event_notes" class="label">Notes</label>

              <div class="control">
                <textarea class="textarea" name="event[notes]" id="event_notes"></textarea>
              </div>
            </div>

            <div class="field mt-5">
              <div class="control">
                <div class="columns">
                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <button type="submit" class="button is-primary is-fullwidth">Create Event</button>
                  </div>

                  <div class="column is-half-tablet is-one-quarter-desktop">
                    <a class="button is-fullwidth has-text-black" href="/roles/pokemon-trainer/events" target="_self">
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

  describe '#routes' do
    include_examples 'should define reader', :routes, -> { routes }
  end

  describe '#singular_resource_name' do
    include_examples 'should define reader',
      :singular_resource_name,
      -> { resource.singular_resource_name }
  end
end
