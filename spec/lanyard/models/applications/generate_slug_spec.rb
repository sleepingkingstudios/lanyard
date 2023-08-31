# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Applications::GenerateSlug do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:current_time) { Time.current }
    let(:attributes)   { {} }
    let(:expected)     { current_time.strftime('%Y-%m-%d') }

    before(:example) do
      allow(Time).to receive(:current).and_return(current_time)
    end

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
      let(:current_time) { Time.current }

      before(:example) do
        allow(Time).to receive(:current).and_return(current_time)

        3.times do
          FactoryBot.create(
            :application,
            :with_job_search,
            created_at: 1.day.ago
          )
        end
      end

      context 'when there are no applications created today' do
        let(:expected) { "#{super()}-0" }

        it 'should return a passing result' do
          expect(command.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      context 'when there are many applications created today' do
        let(:expected) { "#{super()}-3" }

        before(:example) do
          3.times do
            FactoryBot.create(
              :application,
              :with_job_search,
              created_at: current_time
            )
          end
        end

        it 'should return a passing result' do
          expect(command.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected)
        end
      end
    end

    describe 'with attributes { company_name: value }' do
      let(:company_name) { 'Encom Software, Inc' }
      let(:attributes)   { super().merge('company_name' => company_name) }
      let(:expected)     { "#{super()}-encom-software-inc" }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end

      describe 'and { job_title: value }' do
        let(:job_title)  { 'Software Engineer' }
        let(:attributes) { super().merge('job_title' => job_title) }
        let(:expected)   { "#{super()}-software-engineer" }

        it 'should return a passing result' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end
    end

    describe 'with attributes: { job_title: value }' do
      let(:job_title)  { 'Software Engineer' }
      let(:attributes) { super().merge('job_title' => job_title) }
      let(:expected)   { "#{super()}-software-engineer" }

      it 'should return a passing result' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end
    end
  end
end
