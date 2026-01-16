require 'rails_helper'

RSpec.describe CustomFieldValue::Number, type: :model do
  subject { build(:custom_field_value_number, post: post, custom_field: custom_field, value: value) }

  let(:user) { create(:user) }
  let(:post) { create(:post, created_by: user) }
  let(:custom_field) { create(:custom_field_number, options: options) }
  let(:value) { 50 }
  let(:options) { { 'minimum' => 10, 'maximum' => 100 } }

  describe 'validations' do
    context 'when value is below minimum' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 5 }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value is above maximum' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 150 }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value is within range' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 50 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value equals minimum' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 10 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value equals maximum' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 100 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when minimum is not set' do
      let(:options) { { 'maximum' => 100 } }
      let(:value) { 5 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when maximum is not set' do
      let(:options) { { 'minimum' => 10 } }
      let(:value) { 150 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when options are nil' do
      let(:options) { nil }
      let(:value) { 50 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end
end
