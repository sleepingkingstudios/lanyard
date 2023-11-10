# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/event_contracts'

RSpec.describe RoleEvents::StatusEvent, type: :model do
  include Spec::Support::Contracts::EventContracts

  subject(:event) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:       '1982-07-09-status-event',
      event_date: Date.new(1982, 7, 9),
      data:       {},
      notes:      <<~TEXT
        The computers and the programs will start thinking, and the people will stop!
      TEXT
    }
  end

  describe '::AbstractEventError' do
    include_examples 'should define constant',
      :AbstractEventError,
      -> { be < StandardError }
  end

  include_contract 'should be a status event', type: 'RoleEvents::StatusEvent'

  describe '#status' do
    let(:error_message) do
      "#{described_class}#status is an abstract method"
    end

    it 'should raise an exception' do
      expect { event.status }
        .to raise_error described_class::AbstractEventError, error_message
    end
  end

  describe '#update_status' do
    let(:repository) { Cuprum::Rails::Repository.new }
    let(:error_message) do
      "#{described_class}#status is an abstract method"
    end

    it 'should raise an exception' do
      expect { event.update_status(repository: repository) }
        .to raise_error described_class::AbstractEventError, error_message
    end
  end

  describe '#valid_statuses' do
    let(:error_message) do
      "#{described_class}#valid_statuses is an abstract method"
    end

    it 'should raise an exception' do
      expect { event.valid_statuses }
        .to raise_error described_class::AbstractEventError, error_message
    end
  end

  describe '#validate_status_transition' do
    let(:error_message) do
      "#{described_class}#status is an abstract method"
    end

    it 'should raise an exception' do
      expect { event.validate_status_transition }
        .to raise_error described_class::AbstractEventError, error_message
    end
  end
end
