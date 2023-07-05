FactoryBot.define do
  factory :team_account do
    name { "MyString" }
    association :user
  end
end
