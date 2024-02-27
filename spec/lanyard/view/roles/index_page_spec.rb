# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Roles::IndexPage, type: :component do
  subject(:page) { described_class.new(result, resource: resource) }

  include_context 'with mock component', 'table'

  shared_context 'with data' do
    let(:value) do
      {
        'roles' => [{ 'title' => 'Monster Trainer' }]
      }
    end
  end

  let(:value)    { {} }
  let(:result)   { Cuprum::Rails::Result.new(value: value) }
  let(:resource) do
    Librum::Core::Resources::ViewResource.new(
      name:            'roles',
      table_component: Spec::TableComponent
    )
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:resource)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:action_name) { 'index' }
    let(:rendered)    { render_inline(page) }
    let(:tabs_snapshot) do
      <<~HTML.strip
        <div class="tabs">
          <ul>
            <li class="is-active">
              <a class="has-text-link" href="/roles" target="_self">
                All Roles
              </a>
            </li>

            <li>
              <a class="has-text-link" href="/roles/active" target="_self">
                Active
              </a>
            </li>

            <li>
              <a class="has-text-link" href="/roles/inactive" target="_self">
                Inactive
              </a>
            </li>
          </ul>
        </div>
      HTML
    end
    let(:snapshot) do
      <<~HTML
        <div class="level">
          <div class="level-left">
            <div class="level-item">
              <h1 class="title">Roles</h1>
            </div>
          </div>

          <div class="level-right">
            <div class="level-item">
              <a class="button is-primary is-light" href="/roles/new" target="_self">
                Create Role
              </a>
            </div>
          </div>
        </div>

        #{tabs_snapshot}

        <mock name="table" data="[]" resource='#&lt;Resource name="roles"&gt;' routes="[routes]"></mock>
      HTML
    end

    before(:example) do
      routes = resource.routes

      allow(resource).to receive_messages(
        inspect: '#<Resource name="roles">',
        routes:  routes
      )
      allow(routes).to receive(:inspect).and_return('[routes]')

      allow(page).to receive(:action_name).and_return(action_name) # rubocop:disable RSpec/SubjectStub
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with action_name: "active"' do
      let(:action_name) { 'active' }
      let(:tabs_snapshot) do
        <<~HTML.strip
          <div class="tabs">
            <ul>
              <li>
                <a class="has-text-link" href="/roles" target="_self">
                  All Roles
                </a>
              </li>

              <li class="is-active">
                <a class="has-text-link" href="/roles/active" target="_self">
                  Active
                </a>
              </li>

              <li>
                <a class="has-text-link" href="/roles/inactive" target="_self">
                  Inactive
                </a>
              </li>
            </ul>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with action_name: "inactive"' do
      let(:action_name) { 'inactive' }
      let(:tabs_snapshot) do
        <<~HTML.strip
          <div class="tabs">
            <ul>
              <li>
                <a class="has-text-link" href="/roles" target="_self">
                  All Roles
                </a>
              </li>

              <li>
                <a class="has-text-link" href="/roles/active" target="_self">
                  Active
                </a>
              </li>

              <li class="is-active">
                <a class="has-text-link" href="/roles/inactive" target="_self">
                  Inactive
                </a>
              </li>
            </ul>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    wrap_context 'with data' do
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Roles</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button is-primary is-light" href="/roles/new" target="_self">
                  Create Role
                </a>
              </div>
            </div>
          </div>

          #{tabs_snapshot}

          <mock name="table" data='[{"title"=&gt;"Monster Trainer"}]' resource='#&lt;Resource name="roles"&gt;' routes="[routes]"></mock>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
