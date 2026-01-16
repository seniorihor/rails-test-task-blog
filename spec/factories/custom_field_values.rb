FactoryBot.define do
  factory :custom_field_value, class: 'CustomFieldValue' do
    association :post
    association :custom_field, factory: :custom_field_text
    value { "test value" }

    factory :custom_field_value_text, class: 'CustomFieldValue::Text' do
      association :custom_field, factory: :custom_field_text
      value { "test text value" }
    end

    factory :custom_field_value_number, class: 'CustomFieldValue::Number' do
      association :custom_field, factory: :custom_field_number
      value { 50 }
    end

    factory :custom_field_value_select, class: 'CustomFieldValue::Select' do
      association :custom_field, factory: :custom_field_select
      value { [ "option1" ] }
    end

    factory :custom_field_value_multiselect, class: 'CustomFieldValue::Multiselect' do
      association :custom_field, factory: :custom_field_multiselect
      value { [ "option1", "option2" ] }
    end
  end
end
