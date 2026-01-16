class CustomFieldValue::Number < CustomFieldValue
  validates_numericality_of :value,
    greater_than_or_equal_to: ->(record) { record.options["minimum"] },
    if: -> { options&.dig("minimum").present? }

  validates_numericality_of :value,
    less_than_or_equal_to: ->(record) { record.options["maximum"] },
    if: -> { options&.dig("maximum").present? }
end
