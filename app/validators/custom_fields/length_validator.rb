class CustomFields::LengthValidator < ActiveModel::Validator
  def validate(record)
    return unless record.options

    unless record.options.is_a?(Hash)
      record.errors.add(:options, "must be a hash")
      return
    end

    %w[minimum maximum].each do |option|
      if record.options[option] && (!record.options[option].is_a?(Numeric) || record.options[option] < 0)
        record.errors.add(:options, "#{option} must be a positive number")
      end
    end

    return if record.errors.any?

    if record.options["minimum"] && record.options["maximum"] && record.options["minimum"] > record.options["maximum"]
      record.errors.add(:options, "maximum must be greater than or equal to minimum")
    end
  end
end
