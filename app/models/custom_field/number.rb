class CustomField::Number < CustomField
  validates_with CustomFields::LengthValidator
end
