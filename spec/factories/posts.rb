FactoryBot.define do
  factory :post do
    title { "Test Post Title" }
    content { "This is a test post content that is long enough" }
    association :created_by, factory: :user
  end
end
