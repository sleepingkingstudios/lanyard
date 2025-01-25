# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::RoleEvents::Table, type: :component do
  subject(:table) { described_class.new(**constructor_options) }

  shared_context 'with data' do
    let(:role) { FactoryBot.build(:role, :with_cycle, slug: 'pokemon-trainer') }
    let(:data) do
      [
        FactoryBot.build(
          :event,
          role:       role,
          slug:       '1996-09-28-event',
          summary:    'Custom event summary',
          event_date: Date.new(1996, 9, 28)
        ),
        FactoryBot.build(
          :applied_event,
          role:       role,
          slug:       '1996-09-29-applied',
          event_date: Date.new(1996, 9, 29)
        )
      ]
    end
  end

  let(:data) { [] }
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
        .and_keywords(:data, :resource, :routes)
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
              <th>Event</th>

              <th>Date</th>

              <th>Summary</th>

              <th> </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="4">There are no events matching the criteria.</td>
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
                <th>Event</th>

                <th>Date</th>

                <th>Summary</th>

                <th> </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  <a class="has-text-link" href="/roles/pokemon-trainer/events/1996-09-28-event" target="_self">
                    Event
                  </a>
                </td>

                <td>
                  1996-09-28
                </td>

                <td>
                  Custom event summary
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/roles/pokemon-trainer/events/1996-09-29-applied" target="_self">
                    Applied
                  </a>
                </td>

                <td>
                  1996-09-29
                </td>

                <td>
                  Applied directly for the role
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
