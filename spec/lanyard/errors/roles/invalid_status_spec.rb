# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Errors::Roles::InvalidStatus do
  subject(:error) { described_class.new(status: status) }

  let(:status) { 'indeterminate' }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'lanyard.errors.roles.invalid_status'
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:status)
    end
  end

  describe '#as_json' do
    let(:expected) do
      {
        'data'    => { 'status' => status },
        'message' => error.message,
        'type'    => error.type
      }
    end

    include_examples 'should define reader', :as_json, -> { be == expected }
  end

  describe '#message' do
    let(:expected) do
      'invalid status "indeterminate" - valid statuses are "new", "applied", ' \
        '"interviewing", "offered", and "closed"'
    end

    include_examples 'should define reader', :message, -> { expected }
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end

  describe '#type' do
    include_examples 'should define reader', :type, -> { described_class::TYPE }
  end
end
