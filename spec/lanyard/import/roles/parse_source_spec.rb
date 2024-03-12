# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::Roles::ParseSource do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:attributes) { { 'other' => 'value' } }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    describe 'without a source key' do
      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with an empty string' do
      let(:attributes) { super().merge('source' => '') }

      it 'should return a passing result with an empty hash' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(attributes)
      end
    end

    describe 'with a string prefixed with "dice"' do
      let(:attributes) { super().merge('source' => 'Dice') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::DICE)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "dice" and a value' do
      let(:attributes) { super().merge('source' => 'Dice - www.example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::DICE,
          'source_details' => 'www.example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "email"' do
      let(:attributes) { super().merge('source' => 'EMail') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::EMAIL)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "email" and a value' do
      let(:attributes) { super().merge('source' => 'EMail - user@example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::EMAIL,
          'source_details' => 'user@example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "hired"' do
      let(:attributes) { super().merge('source' => 'Hired') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::HIRED)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "hired" and a value' do
      let(:attributes) { super().merge('source' => 'Hired www.example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::HIRED,
          'source_details' => 'www.example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "indeed"' do
      let(:attributes) { super().merge('source' => 'Indeed') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::INDEED)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "indeed" and a value' do
      let(:attributes) { super().merge('source' => 'Indeed www.example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::INDEED,
          'source_details' => 'www.example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "linkedin"' do
      let(:attributes) { super().merge('source' => 'LinkedIn') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::LINKEDIN)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "linkedin" and a value' do
      let(:attributes) { super().merge('source' => 'LinkedIn www.example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::LINKEDIN,
          'source_details' => 'www.example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "referral"' do
      let(:attributes) { super().merge('source' => 'referral') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::REFERRAL)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "referral" and a value' do
      let(:attributes) do
        super().merge('source' => 'Referral user@example.com')
      end
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::REFERRAL,
          'source_details' => 'user@example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "website"' do
      let(:attributes) { super().merge('source' => 'Website') }
      let(:expected_value) do
        attributes.merge('source' => Role::Sources::WEBSITE)
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string prefixed with "website" and a value' do
      let(:attributes) { super().merge('source' => 'Website www.example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::WEBSITE,
          'source_details' => 'www.example.com'
        )
      end

      it 'should return a passing result with the source and details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string formatted like an email' do
      let(:attributes) { super().merge('source' => 'user@example.com') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::EMAIL,
          'source_details' => 'user@example.com'
        )
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string formatted like a dice url' do
      let(:attributes) { super().merge('source' => 'www.dice.com?job_id=0') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::DICE,
          'source_details' => 'www.dice.com?job_id=0'
        )
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string formatted like a hired url' do
      let(:attributes) { super().merge('source' => 'www.hired.com?job_id=0') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::HIRED,
          'source_details' => 'www.hired.com?job_id=0'
        )
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a string formatted like an indeed url' do
      let(:attributes) { super().merge('source' => 'www.indeed.com?job_id=0') }
      let(:expected_value) do
        attributes.merge(
          'source'         => Role::Sources::INDEED,
          'source_details' => 'www.indeed.com?job_id=0'
        )
      end

      it 'should return a passing result with the source' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with a generic string' do
      let(:attributes) do
        source =
          'The lady of the lake, her arm clad in the purest shimmering samite'

        super().merge('source' => source)
      end
      let(:expected_value) do
        attributes
          .dup
          .tap { |hsh| hsh.delete('source') }
          .merge('source_details' => attributes['source'])
      end

      it 'should return a passing result with the source details' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end
  end
end
