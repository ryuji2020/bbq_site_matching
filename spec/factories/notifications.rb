FactoryBot.define do
  factory :notification do
    visitor_id { 1 }
    visited_id { 1 }
    suplurs_land_id { 1 }
    room_id { 1 }
    action { "MyString" }
    checked { false }
  end
end
