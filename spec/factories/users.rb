FactoryBot.define do
  factory :user do
    sequence(:email) {  |n| "#{n}#{Faker::Internet.email}" }
    password { 'password' }
  end
end
