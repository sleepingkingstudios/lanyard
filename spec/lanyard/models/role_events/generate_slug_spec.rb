# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::RoleEvents::GenerateSlug do
  subject(:command) { described_class.new(repository: repository) }

  let(:repository) { Cuprum::Rails::Repository.new }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository)
    end
  end

  describe '#call' do
    shared_context 'when there are non-matching events' do
      before(:example) do
        FactoryBot.create(
          :event,
          :with_role,
          type:       attributes.fetch('type', ''),
          event_date: event_date
        )
        FactoryBot.create(
          :event,
          role:       role,
          type:       attributes.fetch('type', ''),
          event_date: event_date - 1.day
        )
        FactoryBot.create(
          :event,
          role:       role,
          type:       RoleEvents::StatusEvent.name,
          event_date: event_date
        )
      end
    end

    shared_context 'when there are matching events' do
      include_context 'when there are non-matching events'

      before(:example) do
        3.times do
          FactoryBot.create(
            :event,
            role:       role,
            type:       attributes.fetch('type', ''),
            event_date: event_date
          )
        end
      end
    end

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

      describe 'and { event_date: nil }' do
        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
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

        wrap_context 'when there are non-matching events' do
          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end

        wrap_context 'when there are matching events' do
          let(:expected) { "#{super()}-3" }

          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
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

        wrap_context 'when there are non-matching events' do
          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end

        wrap_context 'when there are matching events' do
          let(:expected) { "#{super()}-3" }

          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
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
    end

    describe 'with attributes: { type: value }' do
      let(:type)       { RoleEvents::AppliedEvent.name }
      let(:attributes) { super().merge('type' => type) }
      let(:expected)   { 'applied' }

      describe 'and { event_date: nil }' do
        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
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

        wrap_context 'when there are non-matching events' do
          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end

        wrap_context 'when there are matching events' do
          let(:expected) { "#{super()}-3" }

          it 'should generate the slug' do
            expect(command.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected)
          end
        end
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
