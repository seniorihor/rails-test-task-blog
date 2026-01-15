class CustomFieldValue::Multiselect < CustomFieldValue
  validate -> { errors.add(:value, "must be an array") unless value.is_a?(Array) }
  validates :value,
    inclusion: {
      in: ->(record) { record.custom_field.options },
      allow_blank: true
    }
end
