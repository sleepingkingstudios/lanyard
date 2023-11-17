# frozen_string_literal: true

require 'rails_helper'

require 'support/action'

RSpec.describe Lanyard::Actions::RoleEvents::Concerns::GenerateIndex do
  subject(:action) { described_class.new(action_name, repository: repository) }

  let(:action_name)     { :create }
  let(:described_class) { Spec::Action }
  let(:repository)      { Cuprum::Rails::Repository.new }

  example_class 'Spec::Action', Spec::Support::Action do |klass|
    klass.prepend(Lanyard::Actions::RoleEvents::Concerns::GenerateIndex) # rubocop:disable RSpec/DescribedClass
  end

  describe '#call' do
    describe 'with attributes: an empty Hash' do
      let(:expected_attributes) { { 'event_index' => nil } }

      it 'should set an empty index' do
        expect(action.call(attributes: {}))
          .to be_a_passing_result
          .with_value(expected_attributes)
      end
    end

    describe 'with attributes: { role_id: nil }' do
      let(:attributes)          { { 'role_id' => nil } }
      let(:expected_attributes) { attributes.merge('event_index' => nil) }

      it 'should set an empty index' do
        expect(action.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_attributes)
      end
    end

    describe 'with attributes: { role_id: value }' do
      let(:role_id)             { SecureRandom.uuid }
      let(:attributes)          { { 'role_id' => role_id } }
      let(:expected_attributes) { attributes.merge('event_index' => 0) }

      it 'should set the index to zero' do
        expect(action.call(attributes: attributes))
          .to be_a_passing_result
          .with_value(expected_attributes)
      end

      context 'when the role exists' do
        let(:role)    { FactoryBot.create(:role, :with_cycle) }
        let(:role_id) { role.id }

        it 'should set the index to zero' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      context 'when the role has many events' do
        let(:role)                { FactoryBot.create(:role, :with_cycle) }
        let(:role_id)             { role.id }
        let(:expected_attributes) { attributes.merge('event_index' => 3) }

        before(:example) do
          3.times { FactoryBot.create(:event, role: role) }
        end

        it 'should set the index to the existing event count' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end
  end
end
