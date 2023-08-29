# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::JobSearches::NormalizeDates do
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
          .with_value({})
      end
    end

    describe 'with attributes: { end_date: value }' do
      describe 'with an invalid date' do
        let(:attributes) { super().merge('end_date' => '1982-13') }
        let(:expected)   { attributes.merge('end_date' => nil) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with an invalid string' do
        let(:attributes) { super().merge('end_date' => 'Greetings') }
        let(:expected)   { attributes.merge('end_date' => nil) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year' do
        let(:end_date)   { '1982' }
        let(:attributes) { super().merge('end_date' => end_date) }
        let(:expected) do
          attributes.merge('end_date' => Date.new(1982, 1, 31))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year and a month' do
        let(:end_date)   { '1982-07' }
        let(:attributes) { super().merge('end_date' => end_date) }
        let(:expected) do
          attributes.merge('end_date' => Date.new(1982, 7, 31))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year, a month, and a day' do
        let(:end_date)   { '1982-07-09' }
        let(:attributes) { super().merge('end_date' => end_date) }
        let(:expected) do
          attributes.merge('end_date' => Date.new(1982, 7, 31))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end
    end

    describe 'with attributes: { start_date: value }' do
      describe 'with an invalid date' do
        let(:attributes) { super().merge('start_date' => '1982-13') }
        let(:expected)   { attributes.merge('start_date' => nil) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with an invalid string' do
        let(:attributes) { super().merge('start_date' => 'Greetings') }
        let(:expected)   { attributes.merge('start_date' => nil) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year' do
        let(:start_date) { '1982' }
        let(:attributes) { super().merge('start_date' => start_date) }
        let(:expected) do
          attributes.merge('start_date' => Date.new(1982, 1, 1))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year and a month' do
        let(:start_date) { '1982-07' }
        let(:attributes) { super().merge('start_date' => start_date) }
        let(:expected) do
          attributes.merge('start_date' => Date.new(1982, 7, 1))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'with a year, a month, and a day' do
        let(:start_date) { '1982-07-09' }
        let(:attributes) { super().merge('start_date' => start_date) }
        let(:expected) do
          attributes.merge('start_date' => Date.new(1982, 7, 1))
        end

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end
    end
  end
end
