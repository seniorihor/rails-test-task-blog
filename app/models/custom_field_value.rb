class CustomFieldValue < ApplicationRecord
  belongs_to :post
  belongs_to :custom_field

  validates :value, presence: true, if: -> { custom_field.required? }
end
