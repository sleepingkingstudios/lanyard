# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lanyard::Actions::Applications::Middleware::AssignCurrentJobSearch do # rubocop:disable Layout/LineLength
  subject(:middleware) { described_class.new }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#call' do
    let(:params) { { 'custom_param' => 'custom value' } }
    let(:request) do
      Cuprum::Rails::Request.new(
        body_params:  params,
        params:       params,
        query_params: params
      )
    end
    let(:repository)      { Cuprum::Rails::Repository.new }
    let(:options)         { { 'custom_option' => 'custom value' } }
    let(:next_command)    { Cuprum::Command.new }
    let(:next_value)      { { 'ok' => true } }
    let(:next_result)     { Cuprum::Result.new(value: next_value) }
    let(:expected_params) { params.merge('job_search_id' => nil) }
    let(:expected_request) do
      be_a(Cuprum::Rails::Request).and have_attributes(
        body_params:  params,
        params:       expected_params,
        query_params: expected_params
      )
    end

    before(:example) do
      allow(next_command).to receive(:call).and_return(next_result)
    end

    def call_action
      middleware.call(
        next_command,
        repository: repository,
        request:    request,
        **options
      )
    end

    it 'should define the method' do
      expect(middleware)
        .to be_callable
        .with(1).argument
        .and_keywords(:request, :repository)
        .and_any_keywords
    end

    it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
      call_action

      expect(next_command)
        .to have_received(:call)
        .with(
          repository: repository,
          request:    expected_request,
          **options
        )
    end

    it 'should return a passing result' do
      expect(call_action)
        .to be_a_passing_result
        .with_value(next_value)
    end

    context 'when there are many defined job searches' do
      let(:current_job_search) do
        FactoryBot.build(:job_search, start_date: Date.new(1983, 5))
      end
      let(:expected_params) do
        params.merge('job_search_id' => current_job_search.id)
      end

      before(:example) do
        FactoryBot.create(:job_search, start_date: Date.new(1980, 5))

        current_job_search.save!

        FactoryBot.build(:job_search, start_date: Date.new(1977, 5, 1))
      end

      it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
        call_action

        expect(next_command)
          .to have_received(:call)
          .with(
            repository: repository,
            request:    expected_request,
            **options
          )
      end
    end
  end
end
