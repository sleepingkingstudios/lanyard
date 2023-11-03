# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Errors::Roles::InvalidStatusTransition do
  subject(:error) do
    described_class.new(
      current_status: current_status,
      status:         status,
      valid_statuses: valid_statuses
    )
  end

  let(:current_status) { 'countdown' }
  let(:status)         { 'reentry' }
  let(:valid_statuses) { %w[suborbital orbital aerocapture] }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'lanyard.errors.role_events.invalid_status_transition'
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:current_status, :status, :valid_statuses)
    end
  end

  describe '#as_json' do
    let(:expected) do
      {
        'data'    => {
          'current_status' => current_status,
          'status'         => status,
          'valid_statuses' => valid_statuses
        },
        'message' => error.message,
        'type'    => error.type
      }
    end

    include_examples 'should define reader', :as_json, -> { be == expected }
  end

  describe '#current_status' do
    include_examples 'should define reader',
      :current_status,
      -> { current_status }
  end

  describe '#message' do
    let(:expected) do
      'unable to transition role from status "countdown" to "reentry" - the ' \
        'role must be in status "suborbital", "orbital", or "aerocapture"'
    end

    include_examples 'should define reader', :message, -> { expected }

    context 'when initialized with status: current_status' do
      let(:current_status) { 'reentry' }
      let(:expected)       { 'role is already in status "reentry"' }

      it { expect(error.message).to be == expected }
    end
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end

  describe '#type' do
    include_examples 'should define reader', :type, -> { described_class::TYPE }
  end

  describe '#valid_statuses' do
    include_examples 'should define reader',
      :valid_statuses,
      -> { valid_statuses }
  end
end
