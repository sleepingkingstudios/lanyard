# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::Roles::ParseNotes do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    it { expect(command).to be_callable.with_unlimited_arguments }

    describe 'with no items' do
      it 'should return a passing result' do
        expect(command.call)
          .to be_a_passing_result
          .with_value({})
      end
    end

    describe 'with one item' do
      let(:items) { ['www.example.com'] }
      let(:expected_value) do
        { 'notes' => 'www.example.com' }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with many items' do
      let(:items) do
        [
          'www.example.com',
          'This is an example of notes',
          'These are more notes'
        ]
      end
      let(:expected_value) do
        notes = <<~TEXT.strip
          www.example.com

          This is an example of notes

          These are more notes
        TEXT

        { 'notes' => notes }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "contract"' do
      let(:items) { %w[Contract] }
      let(:expected_value) do
        { 'contract_type' => Role::ContractTypes::CONTRACT }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "contract to hire"' do
      let(:items) { ['Contract To Hire'] }
      let(:expected_value) do
        { 'contract_type' => Role::ContractTypes::CONTRACT_TO_HIRE }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "full time"' do
      let(:items) { %w[full-time] }
      let(:expected_value) do
        { 'contract_type' => Role::ContractTypes::FULL_TIME }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "hybrid"' do
      let(:items) { %w[Hybrid] }
      let(:expected_value) do
        { 'location_type' => Role::LocationTypes::HYBRID }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "hybrid" and a location' do
      let(:items) { ['hybrid Low Earth Orbit'] }
      let(:expected_value) do
        {
          'location'      => 'Low Earth Orbit',
          'location_type' => Role::LocationTypes::HYBRID
        }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "in person"' do
      let(:items) { ['In Person'] }
      let(:expected_value) do
        { 'location_type' => Role::LocationTypes::IN_PERSON }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "in person" and a location' do
      let(:items) { ['in person - the Moon'] }
      let(:expected_value) do
        {
          'location'      => 'the Moon',
          'location_type' => Role::LocationTypes::IN_PERSON
        }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "remote"' do
      let(:items) { %w[remote] }
      let(:expected_value) do
        { 'location_type' => Role::LocationTypes::REMOTE }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with mixed items' do
      let(:items) do
        [
          'remote',
          'www.example.com',
          'Contract To Hire',
          'This is an example of notes'
        ]
      end
      let(:expected_value) do
        notes = <<~TEXT.strip
          www.example.com

          This is an example of notes
        TEXT

        {
          'contract_type' => Role::ContractTypes::CONTRACT_TO_HIRE,
          'location_type' => Role::LocationTypes::REMOTE,
          'notes'         => notes
        }
      end

      it 'should return a passing result' do
        expect(command.call(*items))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end
  end
end
