class Post < ApplicationRecord
  belongs_to :created_by, class_name: "User", inverse_of: :posts

  has_many :custom_field_values, dependent: :destroy, inverse_of: :post

  accepts_nested_attributes_for :custom_field_values, allow_destroy: true

  validates :title, :content, presence: true, length: { minimum: 5 }
  validates :created_by, presence: true
end
