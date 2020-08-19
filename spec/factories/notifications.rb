FactoryBot.define do
  factory :notification do
    visitor { nil }
    visited { nil }
    surplus_land { nil }
    room { nil }
    message { nil }
    comment { nil }
    action { "" }
    checked { false }
  end
end
