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
    let(:role)         { FactoryBot.create(:role, :with_cycle) }
    let(:current_time) { Time.current }
    let(:timestamp)    { current_time.strftime('%Y-%m-%d') }
    let(:attributes)   { { 'role_id' => role.id } }

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

    describe 'with attributes: { type: nil }' do
      let(:expected) { "#{timestamp}-event" }

      it 'should generate the slug' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end

      context 'when there are existing events' do
        before(:example) do
          FactoryBot.create(:event, :with_role, created_at: current_time)
          FactoryBot.create(:event, role: role, created_at: 1.day.ago)
          FactoryBot.create(
            :event,
            created_at: current_time,
            role:       role,
            type:       RoleEvents::StatusEvent.name
          )
        end

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      context 'when there are existing events with the same date and type' do
        let(:expected) { "#{super()}-3" }

        before(:example) do
          3.times do
            FactoryBot.create(:event, role: role, created_at: current_time)
          end
        end

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
      let(:expected)   { "#{timestamp}-applied" }

      it 'should generate the slug' do
        expect(command.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected)
      end

      context 'when there are existing events' do
        before(:example) do
          FactoryBot.create(
            :event,
            :with_role,
            created_at: current_time,
            type:       type
          )
          FactoryBot.create(
            :event,
            role:       role,
            created_at: 1.day.ago,
            type:       type
          )
          FactoryBot.create(
            :event,
            created_at: current_time,
            role:       role,
            type:       RoleEvents::StatusEvent.name
          )
        end

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end

      context 'when there are existing events with the same date and type' do
        let(:expected) { "#{super()}-3" }

        before(:example) do
          3.times do
            FactoryBot.create(
              :event,
              role:       role,
              created_at: current_time,
              type:       type
            )
          end
        end

        it 'should generate the slug' do
          expect(command.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected)
        end
      end
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
