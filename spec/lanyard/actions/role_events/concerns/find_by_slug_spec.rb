# frozen_string_literal: true

require 'rails_helper'

require 'support/action'

RSpec.describe Lanyard::Actions::RoleEvents::Concerns::FindBySlug do
  subject(:action) do
    described_class.new(
      action_name,
      repository: repository,
      resource:   resource
    )
  end

  let(:action_name)     { :show }
  let(:described_class) { Spec::Action }
  let(:repository)      { Cuprum::Rails::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(entity_class: RoleEvent, name: 'events')
  end

  example_class 'Spec::Action', Spec::Support::Action do |klass|
    klass.prepend(Lanyard::Actions::RoleEvents::Concerns::FindBySlug) # rubocop:disable RSpec/DescribedClass

    klass.attr_reader :request

    klass.define_method(:process) do |params:|
      @request = Cuprum::Rails::Request.new(params: params)

      super(attributes: params['event'], primary_key: params['id'])
    end
  end

  describe '#call' do
    let(:params) { {} }

    context 'with action_name: :destroy' do
      let(:action_name) { :destroy }
      let(:params)      { {} }

      describe 'with empty params' do
        let(:expected_error) do
          Cuprum::Rails::Errors::MissingParameter.new(
            parameter_name: 'role_id',
            parameters:     params
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: invalid id }' do
        let(:role_id) { SecureRandom.uuid }
        let(:params)  { super().merge('role_id' => role_id) }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'id',
            attribute_value: role_id,
            collection_name: 'roles',
            primary_key:     true
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: invalid slug }' do
        let(:role_id) { 'invalid-role' }
        let(:params)  { super().merge('role_id' => role_id) }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: role_id,
            collection_name: 'roles',
            primary_key:     false
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: valid id }' do
        let(:role)   { FactoryBot.create(:role, :with_cycle) }
        let(:params) { super().merge('role_id' => role.id) }

        describe 'and { id: invalid id }' do
          let(:id)      { SecureRandom.uuid }
          let(:params)  { super().merge('id' => id) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'id',
              attribute_value: id,
              collection_name: 'events',
              primary_key:     true
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: invalid slug }' do
          let(:slug)    { 'invalid-event' }
          let(:params)  { super().merge('id' => slug) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'slug',
              attribute_value: slug,
              collection_name: 'events',
              primary_key:     false
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: valid id }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.id) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end

        describe 'and { id: valid slug }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.slug) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end
      end

      describe 'with params: { role_id: valid slug }' do
        let(:role)   { FactoryBot.create(:role, :with_cycle) }
        let(:params) { super().merge('role_id' => role.slug) }

        describe 'and { id: invalid id }' do
          let(:id)      { SecureRandom.uuid }
          let(:params)  { super().merge('id' => id) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'id',
              attribute_value: id,
              collection_name: 'events',
              primary_key:     true
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: invalid slug }' do
          let(:slug)    { 'invalid-event' }
          let(:params)  { super().merge('id' => slug) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'slug',
              attribute_value: slug,
              collection_name: 'events',
              primary_key:     false
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: valid id }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.id) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end

        describe 'and { id: valid slug }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.slug) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end
      end
    end

    context 'with action_name: :show' do
      let(:action_name) { :show }
      let(:params)      { {} }

      describe 'with empty params' do
        let(:expected_error) do
          Cuprum::Rails::Errors::MissingParameter.new(
            parameter_name: 'role_id',
            parameters:     params
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: invalid id }' do
        let(:role_id) { SecureRandom.uuid }
        let(:params)  { super().merge('role_id' => role_id) }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'id',
            attribute_value: role_id,
            collection_name: 'roles',
            primary_key:     true
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: invalid slug }' do
        let(:role_id) { 'invalid-role' }
        let(:params)  { super().merge('role_id' => role_id) }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: role_id,
            collection_name: 'roles',
            primary_key:     false
          )
        end

        it 'should return a failing result' do
          expect(action.call(params: params))
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with params: { role_id: valid id }' do
        let(:role)   { FactoryBot.create(:role, :with_cycle) }
        let(:params) { super().merge('role_id' => role.id) }

        describe 'and { id: invalid id }' do
          let(:id)      { SecureRandom.uuid }
          let(:params)  { super().merge('id' => id) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'id',
              attribute_value: id,
              collection_name: 'events',
              primary_key:     true
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: invalid slug }' do
          let(:slug)    { 'invalid-event' }
          let(:params)  { super().merge('id' => slug) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'slug',
              attribute_value: slug,
              collection_name: 'events',
              primary_key:     false
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: valid id }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.id) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end

        describe 'and { id: valid slug }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.slug) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end
      end

      describe 'with params: { role_id: valid slug }' do
        let(:role)   { FactoryBot.create(:role, :with_cycle) }
        let(:params) { super().merge('role_id' => role.slug) }

        describe 'and { id: invalid id }' do
          let(:id)      { SecureRandom.uuid }
          let(:params)  { super().merge('id' => id) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'id',
              attribute_value: id,
              collection_name: 'events',
              primary_key:     true
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: invalid slug }' do
          let(:slug)    { 'invalid-event' }
          let(:params)  { super().merge('id' => slug) }
          let(:expected_error) do
            Cuprum::Collections::Errors::NotFound.new(
              attribute_name:  'slug',
              attribute_value: slug,
              collection_name: 'events',
              primary_key:     false
            )
          end

          it 'should return a failing result' do
            expect(action.call(params: params))
              .to be_a_failing_result
              .with_error(expected_error)
          end
        end

        describe 'and { id: valid id }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.id) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end

        describe 'and { id: valid slug }' do
          let(:event)  { FactoryBot.create(:event, role: role) }
          let(:params) { super().merge('id' => event.slug) }

          it 'should return a passing result with the event' do
            expect(action.call(params: params))
              .to be_a_passing_result
              .with_value(event)
          end
        end
      end
    end
  end
end
