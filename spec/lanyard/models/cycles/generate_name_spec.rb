# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Cycles::GenerateName do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:attributes) { {} }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:attributes)
    end

    it 'should return a passing result' do
      expect(command.call(attributes: attributes))
        .to be_a_passing_result
        .with_value('')
    end

    describe 'with season: value' do
      let(:attributes) { super().merge('season' => 'winter') }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end

      describe 'with year: value' do
        let(:attributes) { super().merge('year' => 1996) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value('Winter 1996')
        end
      end
    end

    describe 'with season_index: value' do
      let(:attributes) { super().merge('season_index' => 0) }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end

      describe 'with year: value' do
        let(:attributes) { super().merge('year' => 1996) }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value('Winter 1996')
        end
      end
    end

    describe 'with year: value' do
      let(:attributes) { super().merge('year' => 1996) }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value('')
      end
    end
  end
end
