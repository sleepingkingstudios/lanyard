# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::RoleEvents::GenerateSlug do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:role)       { FactoryBot.create(:role, :with_cycle) }
    let(:attributes) { { 'role_id' => role.id } }

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

    describe 'with attributes: { type: nil }' do
      let(:expected) { 'event' }

      it 'should generate the slug' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end

      describe 'and { event_date: a Date }' do
        let(:event_date) { Date.new(1982, 7, 9) }
        let(:attributes) { super().merge('event_date' => event_date) }
        let(:expected)   { "1982-07-09-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'and { event_date: a String }' do
        let(:event_date) { Date.new(1982, 7, 9) }
        let(:attributes) { super().merge('event_date' => event_date.iso8601) }
        let(:expected)   { "1982-07-09-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'and { event_date: an invalid String }' do
        let(:attributes) { super().merge('event_date' => '1982-13-32') }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'and { event_index: value }' do
        let(:attributes) { super().merge('event_index' => 3) }
        let(:expected)   { "3-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end

        describe 'and { event_date: value }' do
          let(:event_date) { Date.new(1982, 7, 9) }
          let(:attributes) { super().merge('event_date' => event_date) }
          let(:expected)   { "1982-07-09-#{super()}" }

          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end
      end
    end

    describe 'with attributes: { type: value }' do
      let(:type)       { RoleEvents::AppliedEvent.name }
      let(:attributes) { super().merge('type' => type) }
      let(:expected)   { 'applied' }

      it 'should generate the slug' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end

      describe 'and { event_date: a Date }' do
        let(:event_date) { Date.new(1982, 7, 9) }
        let(:attributes) { super().merge('event_date' => event_date) }
        let(:expected)   { "1982-07-09-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'and { event_date: a String }' do
        let(:event_date) { Date.new(1982, 7, 9) }
        let(:attributes) { super().merge('event_date' => event_date.iso8601) }
        let(:expected)   { "1982-07-09-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      describe 'and { event_index: value }' do
        let(:attributes) { super().merge('event_index' => 3) }
        let(:expected)   { "3-#{super()}" }

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end

        describe 'and { event_date: value }' do
          let(:event_date) { Date.new(1982, 7, 9) }
          let(:attributes) { super().merge('event_date' => event_date) }
          let(:expected)   { "1982-07-09-#{super()}" }

          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end
      end
    end
  end
end
