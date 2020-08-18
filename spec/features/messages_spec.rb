require 'rails_helper'

RSpec.feature "Messages", type: :feature do
  given(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }
  given(:visitor) { create(:user) }
  given(:room) { create(:room, surplus_land: surplus_land, visitor: visitor) }

  scenario 'message exchange of visitor and owner' do
    # visitor側から
    sign_in visitor
    visit room_path(room)
    expect { click_button '送信' }.not_to change(Message, :count)
    expect(page).to have_content '140文字以内でメッセージを入力してください'
    expect do
      fill_in 'message_content', with: 'visitor_message'
      click_button '送信'
    end.to change(Message, :count).by(1)
    visitor_message = Message.last
    expect(visitor_message.sender).to eq visitor
    expect(page).to have_content 'visitor_message'
    expect(page).to have_link '取消', href: room_message_path(room, visitor_message)
    expect do
      click_link '取消'
    end.to change(Message, :count).by(-1)
    expect(page).to have_no_content 'visitor_message'
    fill_in 'message_content', with: 'visitor_message_2'
    click_button '送信'
    # owner側から
    click_link 'ログアウト'
    sign_in room.owner
    visit room_path(room)
    expect(page).to have_content 'visitor_message_2'
    expect(page).to have_no_link '取消'
    expect do
      fill_in 'message_content', with: 'owner_message'
      click_button '送信'
    end.to change(Message, :count).by(1)
    owner_message = Message.last
    expect(owner_message.sender).to eq room.owner
    expect(page).to have_content 'owner_message'
    expect(page).to have_link '取消', href: room_message_path(room, owner_message)
    expect do
      click_link '取消'
    end.to change(Message, :count).by(-1)
    expect(page).to have_no_content 'owner_message'
    expect(page).to have_no_link '取消'
  end
end
