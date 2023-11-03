# frozen_string_literal: true

require 'rails_helper'

require 'support/action'

RSpec.describe Lanyard::Actions::Cycles::Concerns::GenerateName do
  subject(:action) { described_class.new(action_name) }

  let(:action_name)     { :create }
  let(:described_class) { Spec::Action }

  example_class 'Spec::Action', Spec::Support::Action do |klass|
    klass.prepend(Lanyard::Actions::Cycles::Concerns::GenerateName) # rubocop:disable RSpec/DescribedClass
  end

  describe '#call' do
    let(:attributes) { {} }

    context 'when the action is create' do
      let(:action_name) { :create }

      describe 'with an empty attributes Hash' do
        let(:expected_attributes) { attributes.merge('name' => '') }

        it 'should set an empty name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: nil' do
        let(:attributes)          { super().merge('name' => nil) }
        let(:expected_attributes) { attributes.merge('name' => '') }

        it 'should set an empty name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: an empty String' do
        let(:attributes)          { super().merge('name' => '') }
        let(:expected_attributes) { attributes.merge('name' => '') }

        it 'should set an empty name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: a String' do
        let(:attributes)          { super().merge('name' => 'Custom Name') }
        let(:expected_attributes) { attributes.merge('name' => 'Custom Name') }

        it 'should set the specified name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with season: value and year: value' do
        let(:attributes) do
          super().merge('season' => 'winter', 'year' => '1996')
        end
        let(:expected_attributes) { attributes.merge('name' => 'Winter 1996') }

        it 'should generate the name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end

        describe 'with an attributes Hash with name: nil' do
          let(:attributes) { super().merge('name' => nil) }

          it 'should generate the name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end

        describe 'with an attributes Hash with name: an empty String' do
          let(:attributes) { super().merge('name' => '') }

          it 'should generate the name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end

        describe 'with an attributes Hash with name: a String' do
          let(:attributes) { super().merge('name' => 'Custom Name') }
          let(:expected_attributes) do
            attributes.merge('name' => 'Custom Name')
          end

          it 'should set the specified name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end
      end
    end

    context 'when the action is update' do
      let(:action_name) { :update }

      describe 'with an empty attributes Hash' do
        let(:expected_attributes) { attributes }

        it 'should not change the name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: nil' do
        let(:attributes)          { super().merge('name' => nil) }
        let(:expected_attributes) { attributes.merge('name' => '') }

        it 'should set an empty name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: an empty String' do
        let(:attributes)          { super().merge('name' => '') }
        let(:expected_attributes) { attributes.merge('name' => '') }

        it 'should set an empty name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with name: a String' do
        let(:attributes)          { super().merge('name' => 'Custom Name') }
        let(:expected_attributes) { attributes.merge('name' => 'Custom Name') }

        it 'should set the specified name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end
      end

      describe 'with an attributes Hash with season: value and year: value' do
        let(:attributes) do
          super().merge('season' => 'winter', 'year' => '1996')
        end
        let(:expected_attributes) { attributes }

        it 'should not change the name' do
          expect(action.call(attributes: attributes))
            .to be_a_passing_result
            .with_value(expected_attributes)
        end

        describe 'with an attributes Hash with name: nil' do
          let(:attributes) { super().merge('name' => nil) }
          let(:expected_attributes) do
            attributes.merge('name' => 'Winter 1996')
          end

          it 'should generate the name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end

        describe 'with an attributes Hash with name: an empty String' do
          let(:attributes) { super().merge('name' => '') }
          let(:expected_attributes) do
            attributes.merge('name' => 'Winter 1996')
          end

          it 'should generate the name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end

        describe 'with an attributes Hash with name: a String' do
          let(:attributes) { super().merge('name' => 'Custom Name') }
          let(:expected_attributes) do
            attributes.merge('name' => 'Custom Name')
          end

          it 'should set the specified name' do
            expect(action.call(attributes: attributes))
              .to be_a_passing_result
              .with_value(expected_attributes)
          end
        end
      end
    end
  end
end
