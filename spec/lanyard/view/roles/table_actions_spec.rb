# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Roles::TableActions, type: :component do
  subject(:component) { described_class.new(**constructor_options) }

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
    let(:rendered) { render_inline(component) }
    let(:snapshot) do
      <<~HTML
        <div class="buttons" style="margin-top: -.125rem; margin-bottom: -.625rem;">
          <a class="is-small button is-link is-light" href="/roles/indigo-staffing-inc-gym-leader" target="_self">
            Show
          </a>

          <a class="is-small button is-primary is-light" href="/roles/indigo-staffing-inc-gym-leader/events" target="_self">
            Events
          </a>

          <a class="is-small button is-warning is-light" href="/roles/indigo-staffing-inc-gym-leader/edit" target="_self">
            Update
          </a>

          <form action="/roles/indigo-staffing-inc-gym-leader" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <button type="submit" class="button is-danger is-light is-small">Destroy</button>
          </form>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, -> { resource }
  end

  describe '#routes' do
    include_examples 'should define reader', :routes

    it 'should return the resource routes', :aggregate_failures do
      expect(component.routes).to be_a(resource.routes.class)

      expect(component.routes.base_path).to be == resource.routes.base_path
    end

    context 'when initialized with routes: value' do
      let(:routes) do
        Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/path/to/rockets')
      end
      let(:constructor_options) { super().merge(routes: routes) }

      it { expect(component.routes).to be == routes }
    end
  end
end
