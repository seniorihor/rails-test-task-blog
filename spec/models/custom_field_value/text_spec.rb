require 'rails_helper'

RSpec.describe CustomFieldValue::Text, type: :model do
  subject { build(:custom_field_value_text, post: post, custom_field: custom_field, value: value) }

  let(:user) { create(:user) }
  let(:post) { create(:post, created_by: user) }
  let(:custom_field) { create(:custom_field_text, options: options) }
  let(:value) { 'Valid text here' }
  let(:options) { { 'minimum' => 10, 'maximum' => 100 } }

  describe 'validations' do
    context 'when value is below minimum length' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 'short' }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value is above maximum length' do
      let(:options) { { 'minimum' => 10, 'maximum' => 20 } }
      let(:value) { 'a' * 25 }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value is within length range' do
      let(:options) { { 'minimum' => 10, 'maximum' => 100 } }
      let(:value) { 'Valid text here' }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when minimum is not set' do
      let(:options) { { 'maximum' => 100 } }
      let(:value) { 'short' }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when maximum is not set' do
      let(:options) { { 'minimum' => 10 } }
      let(:value) { 'a' * 200 }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when options are nil' do
      let(:options) { nil }
      let(:value) { 'Any text' }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end
end
