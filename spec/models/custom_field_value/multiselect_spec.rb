require 'rails_helper'

RSpec.describe CustomFieldValue::Multiselect, type: :model do
  subject { build(:custom_field_value_multiselect, post: post, custom_field: custom_field, value: value) }

  let(:user) { create(:user) }
  let(:post) { create(:post, created_by: user) }
  let(:custom_field) { create(:custom_field_multiselect, options: options, required: required) }
  let(:value) { [ 'option1', 'option2' ] }
  let(:options) { [ 'option1', 'option2', 'option3' ] }
  let(:required) { false }

  describe 'validations' do
    context 'when value is not an array' do
      let(:value) { 'option1' }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to include('must be an array')
      end
    end

    context 'when value contains option not in custom_field options' do
      let(:options) { [ 'option1', 'option2' ] }
      let(:value) { [ 'option1', 'invalid_option' ] }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value contains valid options' do
      let(:options) { [ 'option1', 'option2', 'option3' ] }
      let(:value) { [ 'option1', 'option2' ] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value is empty array' do
      let(:options) { [ 'option1', 'option2' ] }
      let(:value) { [] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value is nil' do
      let(:options) { [ 'option1', 'option2' ] }
      let(:required) { false }
      let(:value) { nil }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to include('must be an array')
      end
    end
  end
end
