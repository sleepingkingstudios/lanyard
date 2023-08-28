# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobSearch, type: :model do
  include Librum::Core::RSpec::Contracts::ModelContracts

  subject(:job_search) { described_class.new(attributes) }

  let(:attributes) do
    {
      slug:       '1977-05',
      start_date: Date.new(1977, 5, 1)
    }
  end

  include_contract 'should be a model'

  include_contract 'should have many', :applications

  describe '#end_date' do
    include_contract 'should define attribute',
      :end_date,
      value: Date.new(1977, 5, 31)
  end

  describe '#start_date' do
    include_contract 'should define attribute',
      :start_date
  end

  describe '#valid?' do
    it { expect(job_search.valid?).to be true }

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
      attributes: -> { FactoryBot.attributes_for(:job_search) }

    include_contract 'should validate the presence of',
      :start_date

    include_contract 'should validate the uniqueness of',
      :start_date,
      attributes: -> { FactoryBot.attributes_for(:job_search) }

    context 'when end_date is before the end of the month' do
      let(:attributes) { super().merge(end_date: Date.new(1977, 5, 30)) }

      it 'should fail validation' do
        expect(job_search)
          .to have_errors
          .on(:end_date)
          .with_message('must be the last day of the month')
      end
    end

    context 'when start_date is after the start of the month' do
      let(:attributes) { super().merge(start_date: Date.new(1977, 5, 2)) }

      it 'should fail validation' do
        expect(job_search)
          .to have_errors
          .on(:start_date)
          .with_message('must be the first day of the month')
      end
    end
  end
end
