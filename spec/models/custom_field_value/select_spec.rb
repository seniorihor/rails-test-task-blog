require 'rails_helper'

RSpec.describe CustomFieldValue::Select, type: :model do
  subject { build(:custom_field_value_select, post: post, custom_field: custom_field, value: value) }

  let(:user) { create(:user) }
  let(:post) { create(:post, created_by: user) }
  let(:custom_field) { create(:custom_field_select, options: [ 'option1', 'option2' ], required: required) }
  let(:value) { [ 'option1' ] }
  let(:required) { false }

  describe 'validations' do
    context 'when value is not an array' do
      let(:value) { 'option1' }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to include('must be an array')
      end
    end

    context 'when value has more than 1 item' do
      let(:custom_field) { create(:custom_field_select, options: [ 'option1', 'option2', 'option3' ]) }
      let(:value) { [ 'option1', 'option2' ] }

      it { is_expected.to validate_length_of(:value).is_at_most(1) }
    end

    context 'when value is not in options' do
      let(:value) { [ 'invalid_option' ] }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to be_present
      end
    end

    context 'when value is a valid option' do
      let(:value) { [ 'option1' ] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value is empty array' do
      let(:value) { [] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when value is nil' do
      let(:required) { false }
      let(:value) { nil }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:value]).to include('must be an array')
      end
    end
  end
end
