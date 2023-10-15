# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  include Librum::Core::RSpec::Contracts::ModelContracts
  include Librum::Core::RSpec::Contracts::Models::DataPropertiesContracts

  subject(:role) { described_class.new(attributes) }

  shared_context 'with a cycle' do
    let(:cycle)      { FactoryBot.create(:cycle) }
    let(:attributes) { super().merge(cycle: cycle) }
  end

  let(:attributes) do
    {
      slug:         '1982-07-09-encom-programmer',
      company_name: 'Encom',
      job_title:    'Programmer',
      source:       described_class::Sources::REFERRAL,
      data:         {},
      notes:        <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  describe '::CompensationTypes' do
    let(:expected_types) do
      {
        HOURLY:   'hourly',
        SALARIED: 'salaried',
        UNKNOWN:  'unknown'
      }
    end

    include_examples 'should define immutable constant', :CompensationTypes

    it 'should enumerate the types' do
      expect(described_class::CompensationTypes.all).to be == expected_types
    end

    describe '::HOURLY' do
      it 'should store the value' do
        expect(described_class::CompensationTypes::HOURLY).to be == 'hourly'
      end
    end

    describe '::SALARIED' do
      it 'should store the value' do
        expect(described_class::CompensationTypes::SALARIED).to be == 'salaried'
      end
    end

    describe '::UNKNOWN' do
      it 'should store the value' do
        expect(described_class::CompensationTypes::UNKNOWN).to be == 'unknown'
      end
    end
  end

  describe '::ContractTypes' do
    let(:expected_types) do
      {
        CONTRACT:         'contract',
        CONTRACT_TO_HIRE: 'contract_to_hire',
        FULL_TIME:        'full_time',
        UNKNOWN:          'unknown'
      }
    end

    include_examples 'should define immutable constant', :ContractTypes

    it 'should enumerate the types' do
      expect(described_class::ContractTypes.all).to be == expected_types
    end

    describe '::CONTRACT' do
      it 'should store the value' do
        expect(described_class::ContractTypes::CONTRACT).to be == 'contract'
      end
    end

    describe '::CONTRACT_TO_HIRE' do
      it 'should store the value' do
        expect(described_class::ContractTypes::CONTRACT_TO_HIRE)
          .to be == 'contract_to_hire'
      end
    end

    describe '::FULL_TIME' do
      it 'should store the value' do
        expect(described_class::ContractTypes::FULL_TIME).to be == 'full_time'
      end
    end

    describe '::UNKNOWN' do
      it 'should store the value' do
        expect(described_class::ContractTypes::UNKNOWN).to be == 'unknown'
      end
    end
  end

  describe '::LocationTypes' do
    let(:expected_types) do
      {
        HYBRID:    'hybrid',
        IN_PERSON: 'in_person',
        REMOTE:    'remote',
        UNKNOWN:   'unknown'
      }
    end

    include_examples 'should define immutable constant', :LocationTypes

    it 'should enumerate the types' do
      expect(described_class::LocationTypes.all).to be == expected_types
    end

    describe '::HYBRID' do
      it 'should store the value' do
        expect(described_class::LocationTypes::HYBRID).to be == 'hybrid'
      end
    end

    describe '::IN_PERSON' do
      it 'should store the value' do
        expect(described_class::LocationTypes::IN_PERSON).to be == 'in_person'
      end
    end

    describe '::REMOTE' do
      it 'should store the value' do
        expect(described_class::LocationTypes::REMOTE).to be == 'remote'
      end
    end

    describe '::UNKNOWN' do
      it 'should store the value' do
        expect(described_class::LocationTypes::UNKNOWN).to be == 'unknown'
      end
    end
  end

  describe '::Sources' do
    let(:expected_sources) do
      {
        EMAIL:    'email',
        HIRED:    'hired',
        LINKEDIN: 'linkedin',
        OTHER:    'other',
        REFERRAL: 'referral',
        UNKNOWN:  'unknown'
      }
    end

    include_examples 'should define immutable constant', :Sources

    it 'should enumerate the types' do
      expect(described_class::Sources.all).to be == expected_sources
    end

    describe '::EMAIL' do
      it 'should store the value' do
        expect(described_class::Sources::EMAIL).to be == 'email'
      end
    end

    describe '::HIRED' do
      it 'should store the value' do
        expect(described_class::Sources::HIRED).to be == 'hired'
      end
    end

    describe '::LINKEDIN' do
      it 'should store the value' do
        expect(described_class::Sources::LINKEDIN).to be == 'linkedin'
      end
    end

    describe '::OTHER' do
      it 'should store the value' do
        expect(described_class::Sources::OTHER).to be == 'other'
      end
    end

    describe '::REFERRAL' do
      it 'should store the value' do
        expect(described_class::Sources::REFERRAL).to be == 'referral'
      end
    end

    describe '::UNKNOWN' do
      it 'should store the value' do
        expect(described_class::Sources::UNKNOWN).to be == 'unknown'
      end
    end
  end

  describe '::Statuses' do
    let(:expected_statuses) do
      {
        CLOSED: 'closed',
        NEW:    'new',
        OPEN:   'open'
      }
    end

    include_examples 'should define immutable constant', :Statuses

    it 'should enumerate the types' do
      expect(described_class::Statuses.all).to be == expected_statuses
    end

    describe '::CLOSED' do
      it 'should store the value' do
        expect(described_class::Statuses::CLOSED).to be == 'closed'
      end
    end

    describe '::NEW' do
      it 'should store the value' do
        expect(described_class::Statuses::NEW).to be == 'new'
      end
    end

    describe '::OPEN' do
      it 'should store the value' do
        expect(described_class::Statuses::OPEN).to be == 'open'
      end
    end
  end

  include_contract 'should be a model'

  include_contract 'should belong to', :cycle

  include_contract 'should define data property', :benefits, predicate: true

  include_contract 'should define data property', :compensation

  include_contract 'should define data property', :contract_duration

  include_contract 'should define data property', :industry

  include_contract 'should define data property', :location

  include_contract 'should define data property', :time_zone

  describe '#client?' do
    include_examples 'should define predicate', :client?, false

    context 'when initialized with client_name: value' do
      let(:attributes) { super().merge(client_name: 'MCP Consulting') }

      it { expect(role.client?).to be true }
    end
  end

  describe '#client_name' do
    include_contract 'should define attribute',
      :client_name,
      default: '',
      value:   'MCP Consulting'
  end

  describe '#closed_at' do
    include_contract 'should define attribute',
      :closed_at,
      value: Time.zone.at(30.minutes.ago.to_i)
  end

  describe '#company_name' do
    include_contract 'should define attribute',
      :company_name,
      default: ''
  end

  describe '#compensation_type' do
    include_contract 'should define attribute',
      :compensation_type,
      default: described_class::CompensationTypes::UNKNOWN,
      value:   described_class::CompensationTypes::SALARIED
  end

  describe '#contract?' do
    include_examples 'should define predicate', :contract?, false

    context 'when initialized with contract_type: "contract"' do
      let(:attributes) do
        super().merge(contract_type: described_class::ContractTypes::CONTRACT)
      end

      it { expect(role.contract?).to be true }
    end

    context 'when initialized with contract_type: "contract to hire"' do
      let(:attributes) do
        super().merge(
          contract_type: described_class::ContractTypes::CONTRACT_TO_HIRE
        )
      end

      it { expect(role.contract?).to be true }
    end

    context 'when initialized with contract_type: "full time"' do
      let(:attributes) do
        super().merge(contract_type: described_class::ContractTypes::FULL_TIME)
      end

      it { expect(role.contract?).to be false }
    end
  end

  describe '#contract_type' do
    include_contract 'should define attribute',
      :contract_type,
      default: described_class::ContractTypes::UNKNOWN,
      value:   described_class::ContractTypes::FULL_TIME
  end

  describe '#data' do
    include_contract 'should define attribute',
      :data,
      default: {},
      value:   { 'custom_key' => 'custom value' }
  end

  describe '#full_time?' do
    include_examples 'should define predicate', :full_time?, false

    context 'when initialized with contract_type: "contract"' do
      let(:attributes) do
        super().merge(contract_type: described_class::ContractTypes::CONTRACT)
      end

      it { expect(role.full_time?).to be false }
    end

    context 'when initialized with contract_type: "contract to hire"' do
      let(:attributes) do
        super().merge(
          contract_type: described_class::ContractTypes::CONTRACT_TO_HIRE
        )
      end

      it { expect(role.full_time?).to be false }
    end

    context 'when initialized with contract_type: "full time"' do
      let(:attributes) do
        super().merge(contract_type: described_class::ContractTypes::FULL_TIME)
      end

      it { expect(role.full_time?).to be true }
    end
  end

  describe '#hourly?' do
    include_examples 'should define predicate', :hourly?, false

    context 'when initialized with compensation_type: "hourly"' do
      let(:attributes) do
        super().merge(
          compensation_type: described_class::CompensationTypes::HOURLY
        )
      end

      it { expect(role.hourly?).to be true }
    end

    context 'when initialized with compensation_type: "salaried"' do
      let(:attributes) do
        super().merge(
          compensation_type: described_class::CompensationTypes::SALARIED
        )
      end

      it { expect(role.hourly?).to be false }
    end
  end

  describe '#in_person?' do
    include_examples 'should define predicate', :in_person?, false

    context 'when initialized with location_type: "hybrid"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::HYBRID)
      end

      it { expect(role.in_person?).to be true }
    end

    context 'when initialized with location_type: "in_person"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::IN_PERSON)
      end

      it { expect(role.in_person?).to be true }
    end

    context 'when initialized with location_type: "remote"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::REMOTE)
      end

      it { expect(role.in_person?).to be false }
    end
  end

  describe '#job_title' do
    include_contract 'should define attribute',
      :job_title,
      default: ''
  end

  describe '#location_type' do
    include_contract 'should define attribute',
      :location_type,
      default: described_class::LocationTypes::UNKNOWN,
      value:   described_class::LocationTypes::HYBRID
  end

  describe '#notes' do
    include_contract 'should define attribute',
      :notes,
      default: ''
  end

  describe '#opened_at' do
    include_contract 'should define attribute',
      :closed_at,
      value: Time.zone.at(1.hour.ago.to_i)
  end

  describe '#remote?' do
    include_examples 'should define predicate', :remote?, false

    context 'when initialized with location_type: "hybrid"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::HYBRID)
      end

      it { expect(role.remote?).to be false }
    end

    context 'when initialized with location_type: "in_person"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::IN_PERSON)
      end

      it { expect(role.remote?).to be false }
    end

    context 'when initialized with location_type: "remote"' do
      let(:attributes) do
        super().merge(location_type: described_class::LocationTypes::REMOTE)
      end

      it { expect(role.remote?).to be true }
    end
  end

  describe '#salaried?' do
    include_examples 'should define predicate', :salaried?, false

    context 'when initialized with compensation_type: "hourly"' do
      let(:attributes) do
        super().merge(
          compensation_type: described_class::CompensationTypes::HOURLY
        )
      end

      it { expect(role.salaried?).to be false }
    end

    context 'when initialized with compensation_type: "salaried"' do
      let(:attributes) do
        super().merge(
          compensation_type: described_class::CompensationTypes::SALARIED
        )
      end

      it { expect(role.salaried?).to be true }
    end
  end

  describe '#source' do
    include_contract 'should define attribute',
      :source,
      default: 'unknown'
  end

  describe '#status' do
    include_contract 'should define attribute',
      :status,
      default: described_class::Statuses::NEW,
      value:   described_class::Statuses::OPEN
  end

  describe '#valid?' do
    wrap_context 'with a cycle' do
      it { expect(role.valid?).to be true }
    end

    include_contract 'should validate the inclusion of',
      :compensation_type,
      in:        described_class::CompensationTypes.values,
      allow_nil: true

    include_contract 'should validate the inclusion of',
      :contract_type,
      in:        described_class::ContractTypes.values,
      allow_nil: true

    include_contract 'should validate the presence of',
      :cycle,
      message: 'must exist'

    include_contract 'should validate the inclusion of',
      :location_type,
      in:        described_class::LocationTypes.values,
      allow_nil: true

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
      attributes: -> { FactoryBot.attributes_for(:role, :with_cycle) }

    include_contract 'should validate the inclusion of',
      :source,
      in:        described_class::Sources.values,
      allow_nil: true

    include_contract 'should validate the inclusion of',
      :status,
      in:        described_class::Statuses.values,
      allow_nil: true
  end
end
