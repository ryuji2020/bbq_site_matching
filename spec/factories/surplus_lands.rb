FactoryBot.define do
  factory :surplus_land do
    sequence(:title) { |n| "Example Title_#{n}" }
    price { 500 }
    state { "東京" }
    address { '東京都調布市国領町1-2-3' }
    description { "Let's BBQ and Camp !" }
    user { nil }

    association :prefecture

    trait :with_user do
      user
    end
  end
end
