# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Errors::Roles::StatusError do
  subject(:error) { described_class.new(message: message, status: status) }

  let(:message) { 'Something went wrong.' }
  let(:status)  { 'indeterminate' }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'lanyard.errors.roles.status_error'
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:message, :status)
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
    include_examples 'should define reader', :message, -> { message }
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end

  describe '#type' do
    include_examples 'should define reader', :type, -> { described_class::TYPE }
  end
end
