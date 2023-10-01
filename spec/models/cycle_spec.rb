# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cycle, type: :model do
  include Librum::Core::RSpec::Contracts::ModelContracts

  subject(:cycle) { described_class.new(**attributes) }

  let(:attributes) do
    {
      name:         'Winter 1996',
      slug:         'winter-1996',
      year:         '1996',
      season_index: described_class::Seasons::WINTER
    }
  end

  describe '::Seasons' do
    let(:expected_seasons) do
      {
        WINTER: 0,
        SPRING: 1,
        SUMMER: 2,
        AUTUMN: 3
      }
    end

    include_examples 'should define immutable constant', :Seasons

    it 'should enumerate the types' do
      expect(described_class::Seasons.all).to be == expected_seasons
    end

    describe '::AUTUMN' do
      it 'should store the value' do
        expect(described_class::Seasons::AUTUMN).to be 3
      end
    end

    describe '::SPRING' do
      it 'should store the value' do
        expect(described_class::Seasons::SPRING).to be 1
      end
    end

    describe '::SUMMER' do
      it 'should store the value' do
        expect(described_class::Seasons::SUMMER).to be 2
      end
    end

    describe '::WINTER' do
      it 'should store the value' do
        expect(described_class::Seasons::WINTER).to be 0
      end
    end
  end

  include_contract 'should be a model'

  describe '#name' do
    include_contract 'should define attribute', :name, default: ''
  end

  describe '#season' do
    include_examples 'should define reader', :season, 'winter'

    context 'when initialized with season: spring' do
      let(:attributes) do
        super().merge(season_index: described_class::Seasons::SPRING)
      end

      it { expect(cycle.season).to be == 'spring' }
    end

    context 'when initialized with season: summer' do
      let(:attributes) do
        super().merge(season_index: described_class::Seasons::SUMMER)
      end

      it { expect(cycle.season).to be == 'summer' }
    end

    context 'when initialized with season: autumn' do
      let(:attributes) do
        super().merge(season_index: described_class::Seasons::AUTUMN)
      end

      it { expect(cycle.season).to be == 'autumn' }
    end
  end

  describe '#season=' do
    include_examples 'should define writer', :season=

    describe 'with nil' do
      it 'should clear the season' do
        expect { cycle.season = nil }
          .to change(cycle, :season)
          .to be nil
      end

      it 'should clear the season index' do
        expect { cycle.season = nil }
          .to change(cycle, :season_index)
          .to be nil
      end
    end

    describe 'with an invalid season' do
      it 'should clear the season' do
        expect { cycle.season = 'monsoon' }
          .to change(cycle, :season)
          .to be nil
      end

      it 'should clear the season index' do
        expect { cycle.season = 'monsoon' }
          .to change(cycle, :season_index)
          .to be nil
      end
    end

    describe 'with "autumn"' do
      it 'should change the season' do
        expect { cycle.season = 'autumn' }
          .to change(cycle, :season)
          .to be == 'autumn'
      end

      it 'should change the season index' do
        expect { cycle.season = 'autumn' }
          .to change(cycle, :season_index)
          .to be described_class::Seasons::AUTUMN
      end
    end

    describe 'with "spring"' do
      it 'should change the season' do
        expect { cycle.season = 'spring' }
          .to change(cycle, :season)
          .to be == 'spring'
      end

      it 'should change the season index' do
        expect { cycle.season = 'spring' }
          .to change(cycle, :season_index)
          .to be described_class::Seasons::SPRING
      end
    end

    describe 'with "summer"' do
      it 'should change the season' do
        expect { cycle.season = 'summer' }
          .to change(cycle, :season)
          .to be == 'summer'
      end

      it 'should change the season index' do
        expect { cycle.season = 'summer' }
          .to change(cycle, :season_index)
          .to be described_class::Seasons::SUMMER
      end
    end

    describe 'with "winter"' do
      it 'should not change the season' do
        expect { cycle.season = 'winter' }
          .not_to change(cycle, :season)
      end

      it 'should not change the season index' do
        expect { cycle.season = 'winter' }
          .not_to change(cycle, :season_index)
      end
    end

    context 'when initialized with season: spring' do
      let(:attributes) do
        super().merge(season_index: described_class::Seasons::SPRING)
      end

      describe 'with "winter"' do
        it 'should change the season' do
          expect { cycle.season = 'winter' }
            .to change(cycle, :season)
            .to be == 'winter'
        end

        it 'should change the season index' do
          expect { cycle.season = 'winter' }
            .to change(cycle, :season_index)
            .to be described_class::Seasons::WINTER
        end
      end
    end
  end

  describe '#season_index' do
    include_contract 'should define attribute', :season_index
  end

  describe '#valid?' do
    it { expect(cycle).to be_valid }

    include_contract 'should validate the presence of',   :name

    include_contract 'should validate the uniqueness of', :name

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

    include_contract 'should validate the uniqueness of', :slug

    context 'when initialized with season: nil' do
      let(:attributes) do
        super()
          .tap { |hsh| hsh.delete :season_index }
          .merge(season: nil)
      end

      it { expect(cycle).not_to be_valid }

      it 'should validate the season' do
        expect(cycle).to have_errors.on(:season).with_message("can't be blank")
      end
    end

    context 'when initialized with season: an invalid season' do
      let(:attributes) do
        super()
          .tap { |hsh| hsh.delete :season_index }
          .merge(season: 'monsoon')
      end

      it { expect(cycle).not_to be_valid }

      it 'should validate the season' do
        expect(cycle).to have_errors.on(:season).with_message("can't be blank")
      end
    end

    include_contract 'should validate the presence of',
      :year,
      type: String

    include_contract 'should validate the format of',
      :year,
      matching:    {
        '0000' => 'a four-digit string'
      },
      nonmatching: {
        '000A'  => 'a string with non-digit characters',
        '000'   => 'a three-digit string',
        '00000' => 'a five-digit string',
        ' 0000' => 'a string with leading whitespace',
        '0000 ' => 'a string with trailing whitespace'
      }
  end

  describe '#year' do
    include_contract 'should define attribute', :year, default: ''
  end
end
