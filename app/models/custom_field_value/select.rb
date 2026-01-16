class CustomFieldValue::Select < CustomFieldValue
  validate -> { errors.add(:value, "must be an array") unless value.is_a?(Array) }
  validates :value,
    length: { maximum: 1 },
    inclusion: {
      in: ->(record) { record.options },
      allow_blank: true
    }
end
