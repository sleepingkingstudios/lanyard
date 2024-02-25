# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Models::RoleEvents::ValidateRole do
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
    let(:role) { FactoryBot.build(:role) }

    it 'should define the method' do
      expect(command).to be_callable.with(0).arguments.and_keywords(:role)
    end

    it 'should return a passing result' do
      expect(command.call(role: role))
        .to be_a_passing_result
        .with_value(nil)
    end
  end

  describe '#repository' do
    include_examples 'should define reader', :repository, -> { repository }
  end
end
