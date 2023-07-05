FactoryBot.define do
  factory :stock_account do
    name { "MyString" }
    association :user
  end
end
