
FactoryBot.define do
  factory :personal_account do
    name { "MyString" }
    association :user
  end
end