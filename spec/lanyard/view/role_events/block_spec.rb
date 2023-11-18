# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::View::RoleEvents::Block, type: :component do
  subject(:block) { described_class.new(data: data) }

  let(:role) { FactoryBot.build(:role, :with_cycle, slug: 'pokemon-trainer') }
  let(:data) do
    FactoryBot.build(
      :event,
      role:       role,
      slug:       '1996-09-28-event',
      event_date: Date.new(1996, 9, 28),
      notes:      'Release party for Red and Blue editions!'
    )
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
              Event
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Slug
            </div>

            <div class="column">
              1996-09-28-event
            </div>
          </div>

          <div class="columns mb-0">
            <div class="column is-2 has-text-weight-semibold mb-1">
              Event Date
            </div>

            <div class="column">
              1996-09-28
            </div>
          </div>
        </div>

        <h3 class="title is-4">Notes</h3>

        <div class="content">
          Release party for Red and Blue editions!
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end

  describe '#data' do
    include_examples 'should define reader', :data, -> { data }
  end
end
