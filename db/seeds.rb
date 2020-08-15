# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './db/seeds/prefecture.rb'

# サンプルユーザーを作成
User.create!(
  name: 'Example User',
  email: 'example@railstutorial.org',
  gender: '男',
  profile: 'Example profile.',
  password: 'foobar'
)

4.times do |n|
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

# サンプルSurplus_landを作成
users = User.all
users.each do |user|
  5.times do |n|
    title = Faker::University.name
    price = (n + 1) * 100
    state = ['東京都', '神奈川県', '大阪府', '京都府', '北海道']
    address = [
      '新宿区歌舞伎町1-11-8',
      '川崎市多摩区東三田2-1-1',
      '大阪府大阪市中央区大阪城1-1',
      '京都市中央区二条城町541',
      '苫小牧市美園町1-9-3'
    ]
    description = Faker::Lorem.sentence(word_count: 5)
    user.surplus_lands.create!(
      title: title,
      price: price,
      state: state[n],
      address: address[n],
      description: description
    )
  end
end
# 画像を3枚づつ追加
surplus_lands = SurplusLand.all
surplus_lands.each_with_index do |surplus_land, i|
  surplus_land.images.attach(io: File.open(Rails.root.join("db/fixtures/image#{i}.jpg")), filename: "image#{i}.jpg")
end
surplus_lands.each do |surplus_land|
  surplus_land.images.attach(io: File.open(Rails.root.join("db/fixtures/image0.jpg")), filename: "image0.jpg")
end
surplus_lands.each do |surplus_land|
  surplus_land.images.attach(io: File.open(Rails.root.join("db/fixtures/image10.jpg")), filename: "image10.jpg")
end

# お気に入り登録
users[0..2].each do |user|
  5.times do |n|
    user.likes.create!(surplus_land_id: n + 1)
  end
end

users[3..4].each do |user|
  5.times do |n|
    user.likes.create!(surplus_land_id: n + 6)
  end
end

# サンプルフォロー
users = User.all
user = users.first
second_user = users.second
following = users[1..3]
followers = users[1..4]
second_following = users[2..4]
second_followers = users[2..4]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
second_following.each { |followed| second_user.follow(followed) }
second_followers.each { |follower| follower.follow(second_user) }
