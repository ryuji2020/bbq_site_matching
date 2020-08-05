# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './db/seeds/prefecture.rb'

User.create!(
  name: 'Example User',
  email: 'example@railstutorial.org',
  gender: '男',
  profile: 'Example profile.',
  password: 'foobar'
)

8.times do |n|
  name = Faker::Name.name
  email = "example-#{n}@railstutorial.org"
  gender = '男'
  profile = Faker::Lorem.sentence(word_count: 5)
  password = 'password'
  User.create!(
    name: name,
    email: email,
    gender: gender,
    profile: profile,
    password: password
  )
end

users = User.order(:created_at).take(5)
5.times do |n|
  title = Faker::University.name
  price = (n + 1) * 100
  state = ['東京都', '神奈川県', '大阪府', '京都府', '北海道']
  address = Faker::Address.street_address
  description = Faker::Lorem.sentence(word_count: 5)
  images = [File.open("#{Rails.root}/db/fixtures/image#{n}.jpg")]
  users.each do |user|
    user.surplus_lands.create!(
      title: title,
      price: price,
      state: state[n],
      address: address,
      description: description
    )
  end
end

surplus_lands = SurplusLand.all
surplus_lands.each_with_index do |surplus_land, i|
  surplus_land.images.attach(io: File.open(Rails.root.join("db/fixtures/image#{i}.jpg")), filename: "image#{i}.jpg")
end
