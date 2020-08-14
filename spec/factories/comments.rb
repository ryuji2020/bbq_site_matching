FactoryBot.define do
  factory :comment do
    user { nil }
    surplus_land { nil }
    sequence(:body) { |n| "Example_Comment_#{n}" }
  end
end
