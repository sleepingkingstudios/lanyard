# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Import::Errors::ParseError do
  subject(:error) { described_class.new(raw_value: raw_value, **options) }

  let(:raw_value) { 'invalid' }
  let(:options)   { {} }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'lanyard.import.errors.parse_error'
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:entity_class, :message, :raw_value)
    end
  end

  describe '#as_json' do
    let(:expected) do
      {
        'data'    => { 'raw_value' => raw_value },
        'message' => error.message,
        'type'    => error.type
      }
    end

    include_examples 'should define reader', :as_json, -> { be == expected }

    context 'when initialized with entity_class: value' do
      let(:entity_class) { Role }
      let(:options)      { super().merge(entity_class: entity_class) }
      let(:expected) do
        {
          'data'    => {
            'entity_class' => entity_class.name,
            'raw_value'    => raw_value
          },
          'message' => error.message,
          'type'    => error.type
        }
      end

      it { expect(error.as_json).to be == expected }
    end
  end

  describe '#entity_class' do
    include_examples 'should define reader', :entity_class, nil

    context 'when initialized with entity_class: value' do
      let(:entity_class) { Role }
      let(:options)      { super().merge(entity_class: entity_class) }

      it { expect(error.entity_class).to be entity_class }
    end
  end

  describe '#message' do
    let(:expected) { 'Unable to parse value' }

    include_examples 'should define reader', :message, -> { expected }

    context 'when initialized with entity_class: value' do
      let(:entity_class) { Role }
      let(:options)      { super().merge(entity_class: entity_class) }
      let(:expected)     { "#{super()} as #{entity_class.name}" }

      it { expect(error.message).to be == expected }

      context 'and message: value' do # rubocop:disable RSpec/ContextWording
        let(:message)  { 'something went wrong' }
        let(:options)  { super().merge(message: message) }
        let(:expected) { "#{super()} - #{message}" }

        it { expect(error.message).to be == expected }
      end
    end

    context 'when initialized with message: value' do
      let(:message)  { 'something went wrong' }
      let(:options)  { super().merge(message: message) }
      let(:expected) { "#{super()} - #{message}" }

      it { expect(error.message).to be == expected }
    end
  end

  describe '#raw_value' do
    include_examples 'should define reader', :raw_value, -> { raw_value }
  end

  describe '#type' do
    include_examples 'should define reader', :type, -> { described_class::TYPE }
  end
end
