# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Roles::ShowPage, type: :component do
  subject(:page) { described_class.new(result, resource: resource) }

  let(:result)   { Cuprum::Result.new }
  let(:resource) { Cuprum::Rails::Resource.new(entity_class: Role) }

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
    include_context 'with mock component', 'block'

    let(:resource) do
      Librum::Core::Resources::ViewResource.new(
        block_component: Spec::BlockComponent,
        entity_class:    Role
      )
    end
    let(:role) do
      FactoryBot.create(
        :role,
        :with_cycle,
        :applied,
        slug: 'custom-role'
      )
    end
    let(:result)   { Cuprum::Rails::Result.new(value: { 'role' => role }) }
    let(:rendered) { render_inline(page) }
    let(:heading_snapshot) do
      <<~HTML.strip
        <div class="level">
          <div class="level-left">
            <div class="level-item">
              <h1 class="title">Role</h1>
            </div>
          </div>

          <div class="level-right">
            <div class="level-item">
              <a class="button is-warning is-light" href="/roles/custom-role/edit" target="_self">
                Update Role
              </a>
            </div>

            <div class="level-item">
              <form action="/roles/custom-role" accept-charset="UTF-8" method="post">
                <input type="hidden" name="_method" value="delete" autocomplete="off">

                <button type="submit" class="button is-danger is-light">Destroy Role</button>
              </form>
            </div>
          </div>
        </div>
      HTML
    end
    let(:snapshot) do
      <<~HTML
        #{heading_snapshot}

        <mock name="block" data="[role]" resource='#&lt;Resource name="roles"&gt;' routes="[routes]"></mock>

        <p>
          <a class="has-text-link" href="/roles" target="_self">
            <span class="icon-text">
              <span class="icon">
                <i class="fas fa-left-long"></i>
              </span>

              <span>Back to Roles</span>
            </span>
          </a>
        </p>
      HTML
    end

    before(:example) do
      routes = resource.routes

      allow(resource).to receive_messages(
        inspect: '#<Resource name="roles">',
        routes:  routes
      )
      allow(routes).to receive(:inspect).and_return('[routes]')

      allow(role).to receive(:inspect).and_return('[role]')
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a new role' do
      let(:role) do
        FactoryBot.create(
          :role,
          :with_cycle,
          slug: 'custom-role'
        )
      end
      let(:heading_snapshot) do
        <<~HTML.strip
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Role</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <form action="/roles/custom-role/apply" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="patch" autocomplete="off">

                  <button type="submit" class="button is-primary is-light">Apply For Role</button>
                </form>
              </div>

              <div class="level-item">
                <a class="button is-warning is-light" href="/roles/custom-role/edit" target="_self">
                  Update Role
                </a>
              </div>

              <div class="level-item">
                <form action="/roles/custom-role" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="delete" autocomplete="off">

                  <button type="submit" class="button is-danger is-light">Destroy Role</button>
                </form>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with an expiring role' do
      let(:role) do
        FactoryBot.create(
          :role,
          :with_cycle,
          :applied,
          slug:          'custom-role',
          last_event_at: 3.weeks.ago
        )
      end
      let(:heading_snapshot) do
        <<~HTML.strip
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <h1 class="title">Role</h1>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                <form action="/roles/custom-role/expire" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="patch" autocomplete="off">

                  <button type="submit" class="button is-gray is-light">Expire Role</button>
                </form>
              </div>

              <div class="level-item">
                <a class="button is-warning is-light" href="/roles/custom-role/edit" target="_self">
                  Update Role
                </a>
              </div>

              <div class="level-item">
                <form action="/roles/custom-role" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="delete" autocomplete="off">

                  <button type="submit" class="button is-danger is-light">Destroy Role</button>
                </form>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
