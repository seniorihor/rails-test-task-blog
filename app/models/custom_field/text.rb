class CustomField::Text < CustomField
  validates_with CustomFields::LengthValidator
end
