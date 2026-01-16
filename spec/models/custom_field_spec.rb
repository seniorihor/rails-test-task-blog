require 'rails_helper'

RSpec.describe CustomField, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:custom_field_values).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:type) }
  end

  describe 'STI subclasses' do
    it 'has Text subclass' do
      expect(described_class.descendants).to include(CustomField::Text)
    end

    it 'has Number subclass' do
      expect(described_class.descendants).to include(CustomField::Number)
    end

    it 'has Select subclass' do
      expect(described_class.descendants).to include(CustomField::Select)
    end

    it 'has Multiselect subclass' do
      expect(described_class.descendants).to include(CustomField::Multiselect)
    end
  end
end
