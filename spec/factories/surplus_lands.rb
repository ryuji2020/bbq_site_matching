FactoryBot.define do
  factory :surplus_land do
    sequence(:title) { |n| "Example Title_#{n}" }
    price { 500 }
    state { "Tokyo" }
    description { "Let's BBQ and Camp !" }
    user { nil }
  end
end
