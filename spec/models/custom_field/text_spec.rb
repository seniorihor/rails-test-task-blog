require 'rails_helper'

RSpec.describe CustomField::Text, type: :model do
  subject { build(:custom_field_text, options: options) }

  let(:options) { nil }

  describe 'validations' do
    describe 'with LengthValidator' do
      context 'when options is not a hash' do
        let(:options) { [ 'invalid' ] }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:options]).to include('must be a hash')
        end
      end

      context 'when minimum is not a positive number' do
        let(:options) { { 'minimum' => -1 } }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:options]).to include('minimum must be a positive number')
        end
      end

      context 'when maximum is not a positive number' do
        let(:options) { { 'maximum' => -1 } }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:options]).to include('maximum must be a positive number')
        end
      end

      context 'when minimum is greater than maximum' do
        let(:options) { { 'minimum' => 10, 'maximum' => 5 } }

        it 'is invalid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:options]).to include('maximum must be greater than or equal to minimum')
        end
      end

      context 'when options are valid' do
        let(:options) { { 'minimum' => 5, 'maximum' => 100 } }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'when options is nil' do
        let(:options) { nil }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end
  end
end
