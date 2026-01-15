class CustomField::Multiselect < CustomField
  validate -> { errors.add(:options, "must be an array") unless options.is_a?(Array) }
  validates :options, length: { minimum: 2 }
end
