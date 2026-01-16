require 'rails_helper'

RSpec.describe CustomField::Multiselect, type: :model do
  subject { build(:custom_field_multiselect, options: options) }

  let(:options) { [ 'option1', 'option2' ] }

  describe 'validations' do
    context 'when options is not an array' do
      let(:options) { { 'invalid' => 'data' } }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:options]).to include('must be an array')
      end
    end

    context 'when options has less than 2 items' do
      let(:options) { [ 'only_one' ] }

      it { is_expected.to validate_length_of(:options).is_at_least(2) }
    end

    context 'when options has 2 or more items' do
      let(:options) { [ 'option1', 'option2' ] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when options is nil' do
      let(:options) { nil }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:options]).to include('must be an array')
      end
    end
  end
end
