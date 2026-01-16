class CustomFieldValue::Text < CustomFieldValue
  validates_length_of :value,
    minimum: ->(record) { record.options["minimum"] },
    if: -> { options&.dig("minimum").present? }

  validates_length_of :value,
    maximum: ->(record) { record.options["maximum"] },
    if: -> { options&.dig("maximum").present? }
end
