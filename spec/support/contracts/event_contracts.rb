# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'support/contracts'

module Spec::Support::Contracts
  module EventContracts
    # Contract asserting the model class is a valid role event.
    module ShouldBeARoleEvent
      extend RSpec::SleepingKingStudios::Contract

      contract do |type:, **options|
        include Librum::Core::RSpec::Contracts::ModelContracts
        include Librum::Core::RSpec::Contracts::Models::DataPropertiesContracts

        shared_context 'with a role' do
          let(:role)       { FactoryBot.create(:role, :with_cycle) }
          let(:attributes) { super().merge(role: role) }
        end

        describe '.abstract_event?' do
          let(:expected) { options[:abstract] || false }

          it 'should define the class predicate' do
            expect(described_class)
              .to respond_to(:abstract_event?)
              .with(0).arguments
          end

          it { expect(described_class.abstract_event?).to be expected }
        end

        include_contract 'should be a model'

        include_contract 'should belong to',
          :role,
          association: -> { FactoryBot.create(:role, :with_cycle) }

        describe '#data' do
          include_contract 'should define attribute',
            :data,
            default: {},
            value:   { 'custom_key' => 'custom value' }
        end

        describe '#event_date' do
          include_contract 'should define attribute', :event_date
        end

        describe '#name' do
          let(:expected) do
            next 'Event' if event.type.blank?

            event.type.split('::').last.sub(/Event\z/, '')
          end

          include_examples 'should define reader', :name, -> { expected }
        end

        describe '#notes' do
          include_contract 'should define attribute',
            :notes,
            default: ''
        end

        describe '#type' do
          include_examples 'should define reader', :type, type
        end

        describe '#valid?' do
          if options[:abstract]
            it 'should validate the event type' do
              expect(subject)
                .to have_errors
                .on(:type)
                .with_message('is an abstract event')
            end
          else
            wrap_context 'with a role' do
              it { expect(subject.valid?).to be true }
            end
          end

          include_contract 'should validate the presence of',
            :role,
            message: 'must exist'

          include_contract 'should validate the presence of', :event_date

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

          unless options[:abstract]
            include_contract 'should validate the uniqueness of',
              :slug,
              attributes:   lambda {
                FactoryBot.attributes_for(:event, :with_role)
              },
              factory_name: :event
          end
        end
      end
    end

    # Contract asserting the model class is a valid status event.
    module ShouldBeAStatusEvent
      extend RSpec::SleepingKingStudios::Contract

      contract do |type:, **options|
        include Spec::Support::Contracts::EventContracts

        include_contract 'should be a role event',
          abstract: options[:abstract],
          type:     type

        describe '#status' do
          let(:expected_status) { options.fetch(:status) }

          include_examples 'should define reader', :status

          next unless options.key?(:status)

          it { expect(subject.status).to be == expected_status }
        end

        describe '#update_status' do
          let(:repository) { Cuprum::Rails::Repository.new }
          let(:command) { subject.update_status(repository: repository) }
          let(:command_class) do
            Lanyard::Models::Roles::UpdateStatus
          end

          it 'should define the method' do
            expect(subject)
              .to respond_to(:update_status)
              .with(0).arguments
              .and_keywords(:repository)
          end

          next unless options.key?(:status)

          it { expect(command).to be_a command_class }

          it { expect(command.repository).to be repository }

          it { expect(command.status).to be == subject.status }
        end

        describe '#valid_statuses' do
          let(:expected_statuses) { options.fetch(:valid_statuses) }

          include_examples 'should define reader', :valid_statuses

          next unless options.key?(:valid_statuses)

          it { expect(subject.valid_statuses).to be == expected_statuses }
        end

        describe '#validate_status_transition' do
          let(:command) { subject.validate_status_transition }
          let(:command_class) do
            Lanyard::Models::Roles::ValidateStatusTransition
          end
          let(:expected_statuses) do
            Set.new(subject.valid_statuses)
          end

          it 'should define the method' do
            expect(subject)
              .to respond_to(:validate_status_transition)
              .with(0).arguments
          end

          next unless options.key?(:status) && options.key?(:valid_statuses)

          it { expect(command).to be_a command_class }

          it { expect(command.status).to be == subject.status }

          it { expect(command.valid_statuses).to be == expected_statuses }
        end
      end
    end
  end
end
