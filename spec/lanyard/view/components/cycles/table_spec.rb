# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::Cycles::Table, type: :component do
  subject(:table) { described_class.new(**constructor_options) }

  shared_context 'with data' do
    let(:data) do
      [
        FactoryBot.build(:cycle, year: '1996', season: 'winter'),
        FactoryBot.build(:cycle, year: '1999', season: 'autumn'),
        FactoryBot.build(:cycle, year: '2000', season: 'autumn')
      ]
    end
  end

  let(:data)     { [] }
  let(:resource) { Cuprum::Rails::Resource.new(resource_name: 'cycles') }
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
              <th>Name</th>

              <th>Active</th>

              <th>UI Eligible</th>

              <th> </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="4">There are no cycles matching the criteria.</td>
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
                <th>Name</th>

                <th>Active</th>

                <th>UI Eligible</th>

                <th> </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  <a class="has-text-link" href="/cycles/winter-1996" target="_self">
                    Winter 1996
                  </a>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/cycles/autumn-1999" target="_self">
                    Autumn 1999
                  </a>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  [actions]
                </td>
              </tr>

              <tr>
                <td>
                  <a class="has-text-link" href="/cycles/autumn-2000" target="_self">
                    Autumn 2000
                  </a>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
                </td>

                <td>
                  <span class="icon has-text-danger">
                    <i class="fas fa-xmark"></i>
                  </span>
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
