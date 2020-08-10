FactoryBot.define do
  factory :comment do
    user { nil }
    surplus_land { nil }
    body { "MyText" }
  end
end
