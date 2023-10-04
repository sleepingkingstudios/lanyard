# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::Components::Cycles::Block, type: :component do
  subject(:block) { described_class.new(data: data) }

  let(:data) { FactoryBot.build(:cycle, year: '1996', season: 'winter') }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:data)
        .and_any_keywords
    end
  end

  describe '#call' do
    let(:rendered) { render_inline(block) }
    let(:snapshot) do
      <<~HTML
        <div class="block content">
          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Name
            </div>

            <div class="column">
              Winter 1996
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Slug
            </div>

            <div class="column">
              winter-1996
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Year
            </div>

            <div class="column">
              1996
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Season
            </div>

            <div class="column">
              Winter
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end
end
