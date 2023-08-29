# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Actions::JobSearches::Concerns::NormalizeDates,
  type: :action \
do
  subject(:action) { described_class.new(action_name) }

  let(:action_name)     { :create }
  let(:described_class) { Spec::Action }

  example_class 'Spec::Action', Cuprum::Command do |klass|
    klass.prepend(Lanyard::Actions::JobSearches::Concerns::NormalizeDates) # rubocop:disable RSpec/DescribedClass

    klass.define_method(:initialize) do |action|
      @action = action
    end

    klass.attr_reader :action

    klass.define_method(:create_entity) do |attributes:|
      attributes
    end

    klass.define_method(:update_entity) do |attributes:|
      attributes
    end

    klass.define_method(:process) do |attributes:|
      if action == :create
        create_entity(attributes: attributes)
      else
        update_entity(attributes: attributes)
      end
    end
  end

  describe '#call' do
    context 'when the action is create' do
      let(:action_name) { :create }

      describe 'with attributes: an empty Hash' do
        let(:expected_attributes) { {} }

        it 'should return a passing result' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { end_date: an empty String }' do
        let(:expected_attributes) { { 'end_date' => nil } }

        it 'should return a passing result' do
          expect(action.call(attributes: { 'end_date' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { end_date: a String }' do
        let(:expected_attributes) do
          { 'end_date' => Date.new(1982, 7, 31) }
        end

        it 'should return a passing result' do
          expect(action.call(attributes: { 'end_date' => '1982-07' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { start_date: an empty String }' do
        let(:expected_attributes) { { 'start_date' => nil } }

        it 'should return a passing result' do
          expect(action.call(attributes: { 'start_date' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { start_date: a String }' do
        let(:expected_attributes) do
          { 'start_date' => Date.new(1982, 7, 1) }
        end

        it 'should return a passing result' do
          expect(action.call(attributes: { 'start_date' => '1982-07' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end

    context 'when the action is update' do
      let(:action_name) { :update }

      describe 'with attributes: an empty Hash' do
        let(:expected_attributes) { {} }

        it 'should return a passing result' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { end_date: an empty String }' do
        let(:expected_attributes) { { 'end_date' => nil } }

        it 'should return a passing result' do
          expect(action.call(attributes: { 'end_date' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { end_date: a String }' do
        let(:expected_attributes) do
          { 'end_date' => Date.new(1982, 7, 31) }
        end

        it 'should return a passing result' do
          expect(action.call(attributes: { 'end_date' => '1982-07' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { start_date: an empty String }' do
        let(:expected_attributes) { { 'start_date' => nil } }

        it 'should return a passing result' do
          expect(action.call(attributes: { 'start_date' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { start_date: a String }' do
        let(:expected_attributes) do
          { 'start_date' => Date.new(1982, 7, 1) }
        end

        it 'should return a passing result' do
          expect(action.call(attributes: { 'start_date' => '1982-07' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end
  end
end
