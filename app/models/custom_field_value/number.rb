class CustomFieldValue::Number < CustomFieldValue
  validates_numericality_of :value,
    greater_than_or_equal_to: ->(record) { record.custom_field.options["minimum"] },
    if: ->(record) { record.custom_field.options["minimum"].present? }

  validates_numericality_of :value,
    less_than_or_equal_to: ->(record) { record.custom_field.options["maximum"] },
    if: ->(record) { record.custom_field.options["maximum"].present? }
end
