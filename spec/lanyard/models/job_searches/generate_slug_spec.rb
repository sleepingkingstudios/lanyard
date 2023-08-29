# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::JobSearches::GenerateSlug do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:attributes) { {} }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    describe 'with attributes: nil' do
      let(:error_message) { 'attributes must be a Hash' }

      it 'should raise an exception' do
        expect { command.call(attributes: nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attributes: an Object' do
      let(:error_message) { 'attributes must be a Hash' }

      it 'should raise an exception' do
        expect { command.call(attributes: Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with attributes: an empty Hash' do
      it 'should return a passing result' do
        expect(command.call(attributes: {}))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with attributes: { start_date: nil }' do
      let(:attributes) { super().merge('start_date' => nil) }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with attributes: { start_date: an empty String }' do
      let(:attributes) { super().merge('start_date' => '') }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end

    describe 'with attributes: { start_date: value }' do
      let(:start_date) { Date.new(1982, 7) }
      let(:attributes) { super().merge('start_date' => start_date) }
      let(:expected)   { '1982-07' }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end
    end
  end
end
