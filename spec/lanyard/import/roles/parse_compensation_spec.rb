# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::Roles::ParseCompensation do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:attributes) { { 'other' => 'value' } }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    describe 'without a compensation key' do
      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with compensation: a String' do
      let(:attributes) { super().merge('compensation' => 'Cash') }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with compensation: an hourly rate' do
      let(:attributes) { super().merge('compensation' => '$100/hr') }
      let(:expected_value) do
        attributes.merge(
          'compensation_type' => Role::CompensationTypes::HOURLY
        )
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with compensation: a salaried rate' do
      let(:attributes) { super().merge('compensation' => '$100,000/yr') }
      let(:expected_value) do
        attributes.merge(
          'compensation_type' => Role::CompensationTypes::SALARIED
        )
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end
  end
end
