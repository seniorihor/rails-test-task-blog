require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:created_by).class_name('User') }
    it { is_expected.to have_many(:custom_field_values).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:created_by) }
    it { is_expected.to validate_length_of(:title).is_at_least(5) }
    it { is_expected.to validate_length_of(:content).is_at_least(5) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:custom_field_values).allow_destroy(true) }
  end
end
