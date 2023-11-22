# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::Roles::ValidateStatusTransition do
  subject(:command) do
    described_class.new(status: status, valid_statuses: valid_statuses)
  end

  let(:status)         { 'offered' }
  let(:valid_statuses) { %w[applied interviewing] }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:status, :valid_statuses)
    end
  end

  describe '#call' do
    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:role)
    end

    describe 'with role: a role with invalid status' do
      let(:role) do
        FactoryBot.build(:role, status: Role::Statuses::CLOSED)
      end
      let(:expected_error) do
        Lanyard::Errors::Roles::InvalidStatusTransition.new(
          current_status: role.status,
          status:         status,
          valid_statuses: valid_statuses
        )
      end

      it 'should return a failing result' do
        expect(command.call(role: role))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with role: a role with valid status' do
      let(:role) do
        FactoryBot.build(:role, status: Role::Statuses::INTERVIEWING)
      end

      it 'should return a passing result' do
        expect(command.call(role: role))
          .to be_a_passing_result
          .with_value(nil)
      end
    end
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end

  describe '#valid_statuses' do
    include_examples 'should define reader',
      :valid_statuses,
      -> { Set.new(valid_statuses) }
  end
end
