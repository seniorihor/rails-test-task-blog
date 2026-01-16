require 'rails_helper'

RSpec.describe CustomFieldValue, type: :model do
  subject { build(:custom_field_value, custom_field: custom_field, value: value) }

  let(:custom_field) { create(:custom_field_text, required: required) }
  let(:value) { nil }
  let(:required) { false }

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:custom_field) }
  end

  describe 'validations' do
    describe 'presence of value' do
      context 'when custom_field is required' do
        let(:required) { true }

        it { is_expected.to validate_presence_of(:value) }
      end

      context 'when custom_field is not required' do
        let(:required) { false }

        it { is_expected.not_to validate_presence_of(:value) }
      end
    end
  end
end
