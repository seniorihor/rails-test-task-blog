class CustomFieldValue::Text < CustomFieldValue
  validates_length_of :value,
    minimum: ->(record) { record.custom_field.options["minimum"] },
    if: ->(record) { record.value.present? && record.custom_field.options["minimum"].present? }

  validates_length_of :value,
    maximum: ->(record) { record.custom_field.options["maximum"] },
    if: ->(record) { record.value.present? && record.custom_field.options["maximum"].present? }
end
