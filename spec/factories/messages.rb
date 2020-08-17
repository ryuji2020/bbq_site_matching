FactoryBot.define do
  factory :message do
    content { "MyText" }
    room { nil }
    sender_id { 1 }
    receiver_id { 1 }
  end
end
