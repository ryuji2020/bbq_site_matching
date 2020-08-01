FactoryBot.define do
  factory :surplus_land do
    sequence(:title) { |n| "Example Title_#{n}" }
    price { 500 }
    state { "東京" }
    description { "Let's BBQ and Camp !" }
    user { nil }

    association :prefecture

    trait :with_user do
      user
    end
  end
end
