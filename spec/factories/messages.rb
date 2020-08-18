FactoryBot.define do
  factory :message do
    sequence(:content) { |n| "Example Message_#{n}" }
    room { nil }
    sender { nil }
    receiver { nil }
  end
end
