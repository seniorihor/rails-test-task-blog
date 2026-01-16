FactoryBot.define do
  factory :custom_field, class: 'CustomField' do
    name { "Test Field" }
    required { false }
    options { nil }

    factory :custom_field_text, class: 'CustomField::Text' do
      type { "CustomField::Text" }
    end

    factory :custom_field_number, class: 'CustomField::Number' do
      type { "CustomField::Number" }
    end

    factory :custom_field_select, class: 'CustomField::Select' do
      type { "CustomField::Select" }
      options { [ "option1", "option2" ] }
    end

    factory :custom_field_multiselect, class: 'CustomField::Multiselect' do
      type { "CustomField::Multiselect" }
      options { [ "option1", "option2" ] }
    end
  end
end
