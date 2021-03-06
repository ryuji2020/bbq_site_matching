FactoryBot.define do
  factory :surplus_land do
    sequence(:title) { |n| "Example Title_#{n}" }
    price { 500 }
    state { "東京都" }
    address { '東京都調布市国領町1-2-3' }
    description { "Let's BBQ and Camp !" }
    images { [Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/valid.png'), 'image/png')] }
    user { nil }

    trait :with_prefecture do
      prefecture
    end

    trait :with_user do
      user
    end
  end
end
