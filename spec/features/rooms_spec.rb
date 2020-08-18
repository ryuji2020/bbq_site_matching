require 'rails_helper'

RSpec.feature "Rooms", type: :feature do
  given(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }
  given(:visitor) { create(:user) }

  scenario 'apply and create the talk-room' do
    # サインイン前は申込みボタンは表示されない
    visit surplus_land_path(surplus_land)
    expect(page).to have_no_button '申し込む'
    # surplus_landの所有者自身でログインしても申し込みボタンは表示されない
    sign_in surplus_land.user
    visit surplus_land_path(surplus_land)
    expect(page).to have_no_button '申し込む'
    # visitorでログイン
    click_link 'ログアウト'
    sign_in visitor
    visit surplus_land_path(surplus_land)
    expect(page).to have_button '申し込む'
    expect do
      click_button '申し込む'
    end.to change(Room, :count).by(1)
    room = Room.last
    message = Message.last
    expect(current_path).to eq room_path(room)
    expect(message.sender).to eq visitor
    expect(message.content).to eq '行ってみたいです！'
    expect(page).to have_content '行ってみたいです！'
    # 2度目の申込み
    visit surplus_land_path(surplus_land)
    expect(page).to have_link 'もう一度申し込む', href: room_path(room)
    expect do
      click_link 'もう一度申し込む'
    end.to change(Message, :count).by(1)
    message = Message.last
    expect(message.sender).to eq visitor
    expect(message.content).to eq 'もう一度行きたいです！'
  end
end
