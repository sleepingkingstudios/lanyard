# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::Roles::ParseNotes do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:attributes) { { 'other' => 'value' } }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    describe 'without a notes key' do
      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with notes: a String' do
      let(:attributes) { super().merge('notes' => 'www.example.com') }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with one item' do
      let(:attributes)     { super().merge('notes' => ['www.example.com']) }
      let(:expected_value) { attributes.merge('notes' => 'www.example.com') }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with many items' do
      let(:attributes) do
        super().merge(
          'notes' => [
            'www.example.com',
            'This is an example of notes',
            'These are more notes'
          ]
        )
      end
      let(:expected_value) do
        notes = <<~TEXT.strip
          www.example.com

          This is an example of notes

          These are more notes
        TEXT

        attributes.merge('notes' => notes)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "contract"' do
      let(:attributes) { super().merge('notes' => %w[Contract]) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('contract_type' => Role::ContractTypes::CONTRACT)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "contract to hire"' do
      let(:attributes) { super().merge('notes' => ['Contract To Hire']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('contract_type' => Role::ContractTypes::CONTRACT_TO_HIRE)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with contract_type: "full time"' do
      let(:attributes) { super().merge('notes' => ['full-time']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('contract_type' => Role::ContractTypes::FULL_TIME)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "hybrid"' do
      let(:attributes) { super().merge('notes' => ['hybrid']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('location_type' => Role::LocationTypes::HYBRID)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "hybrid" and a location' do
      let(:attributes) { super().merge('notes' => ['hybrid Low Earth Orbit']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge(
            'location'      => 'Low Earth Orbit',
            'location_type' => Role::LocationTypes::HYBRID
          )
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "in person"' do
      let(:attributes) { super().merge('notes' => ['In Person']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('location_type' => Role::LocationTypes::IN_PERSON)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "in person" and a location' do
      let(:attributes) { super().merge('notes' => ['in person - the Moon']) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge(
            'location'      => 'the Moon',
            'location_type' => Role::LocationTypes::IN_PERSON
          )
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with location_type: "remote"' do
      let(:attributes) { super().merge('notes' => %w[remote]) }
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('notes') }
          .merge('location_type' => Role::LocationTypes::REMOTE)
      end

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with mixed items' do
      let(:attributes) do
        super().merge(
          'notes' => [
            'hybrid - Low Earth Orbit',
            'www.example.com',
            'Contract To Hire',
            'This is an example of notes'
          ]
        )
      end
      let(:expected_value) do
        notes = <<~TEXT.strip
          www.example.com

          This is an example of notes
        TEXT

        attributes.merge(
          'contract_type' => Role::ContractTypes::CONTRACT_TO_HIRE,
          'location'      => 'Low Earth Orbit',
          'location_type' => Role::LocationTypes::HYBRID,
          'notes'         => notes
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
