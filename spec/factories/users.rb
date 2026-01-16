FactoryBot.define do
  factory :user do
    username { "testuser#{rand(1000)}" }
    first_name { "Test" }
    last_name { "User" }
    email { "test#{rand(1000)}@example.com" }
  end
end
