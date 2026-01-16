class CustomField < ApplicationRecord
  has_many :custom_field_values, dependent: :destroy

  validates :name, :type, presence: true
end
