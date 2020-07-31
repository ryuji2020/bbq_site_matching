FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Example_#{n} User" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
