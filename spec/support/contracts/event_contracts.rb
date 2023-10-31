# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'support/contracts'

module Spec::Support::Contracts
  module EventContracts
    # Contract asserting the model class is a valid role event.
    module ShouldBeARoleEvent
      extend RSpec::SleepingKingStudios::Contract

      contract do |type:|
        include Librum::Core::RSpec::Contracts::ModelContracts
        include Librum::Core::RSpec::Contracts::Models::DataPropertiesContracts

        shared_context 'with a role' do
          let(:role)       { FactoryBot.create(:role, :with_cycle) }
          let(:attributes) { super().merge(role: role) }
        end

        include_contract 'should be a model'

        include_contract 'should belong to',
          :role,
          association: -> { FactoryBot.create(:role, :with_cycle) }

        describe '#close_event?' do
          include_examples 'should define predicate', :close_event?, false
        end

        describe '#data' do
          include_contract 'should define attribute',
            :data,
            default: {},
            value:   { 'custom_key' => 'custom value' }
        end

        describe '#notes' do
          include_contract 'should define attribute',
            :notes,
            default: ''
        end

        describe '#open_event?' do
          include_examples 'should define predicate', :open_event?, false
        end

        describe '#type' do
          include_examples 'should define reader', :type, type
        end

        describe '#valid?' do
          wrap_context 'with a role' do
            it { expect(event.valid?).to be true }
          end

          include_contract 'should validate the presence of',
            :role,
            message: 'must exist'

          include_contract 'should validate the format of',
            :slug,
            message:     'must be in kebab-case',
            matching:    {
              'example'               => 'a lowercase string',
              'example-slug'          => 'a kebab-case string',
              'example-compound-slug' => # rubocop:disable Layout/HashAlignment
                'a kebab-case string with multiple words',
              '1st-example'           => 'a kebab-case string with digits'
            },
            nonmatching: {
              'InvalidSlug'   => 'a string with capital letters',
              'invalid slug'  => 'a string with whitespace',
              'invalid_slug'  => 'a string with underscores',
              '-invalid-slug' => 'a string with leading dash',
              'invalid-slug-' => 'a string with trailing dash'
            }

          include_contract 'should validate the presence of',
            :slug,
            type: String

          include_contract 'should validate the uniqueness of',
            :slug,
            attributes:   -> { FactoryBot.attributes_for(:event, :with_role) },
            factory_name: :event
        end
      end
    end
  end
end
