# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Actions::Roles::Concerns::GenerateSlug do
  subject(:action) { described_class.new(action_name, repository: repository) }

  let(:action_name)     { :create }
  let(:described_class) { Spec::Action }
  let(:repository)      { Cuprum::Rails::Repository.new }

  example_class 'Spec::Action', Cuprum::Command do |klass|
    klass.prepend(Lanyard::Actions::Roles::Concerns::GenerateSlug) # rubocop:disable RSpec/DescribedClass

    klass.define_method(:initialize) do |action, repository:|
      @action     = action
      @repository = repository
    end

    klass.attr_reader :action

    klass.attr_reader :repository

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
    let(:command_class) { Lanyard::Models::Roles::GenerateSlug }
    let(:command) do
      instance_double(
        Librum::Core::Models::Attributes::GenerateSlug,
        call: result
      )
    end
    let(:result) do
      Cuprum::Result.new(value: 'example-slug')
    end

    before(:example) do
      allow(command_class).to receive(:new).and_return(command)
    end

    context 'when the action is create' do
      let(:action_name) { :create }

      describe 'with attributes: an empty Hash' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { slug: an empty String }' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes { slug: a String }' do
        let(:expected_attributes) { { 'slug' => 'custom-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => 'custom-slug' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end

    context 'when the action is update' do
      let(:action_name) { :update }

      describe 'with attributes: an empty Hash' do
        let(:expected_attributes) { {} }

        it 'should set an empty slug' do
          expect(action.call(attributes: {}))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { slug: an empty String }' do
        let(:expected_attributes) { { 'slug' => 'example-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => '' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with attributes: { slug: a String }' do
        let(:expected_attributes) { { 'slug' => 'custom-slug' } }

        it 'should set an empty slug' do
          expect(action.call(attributes: { 'slug' => 'custom-slug' }))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end
    end
  end
end
