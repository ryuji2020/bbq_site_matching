require 'rails_helper'

RSpec.feature "Notifications", type: :feature do
  given(:user) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:surplus_land) { create(:surplus_land, :with_prefecture, user: user) }

  scenario 'users notification-page is displayed correctly' do
    sign_in visitor
    # フォローする
    visit user_path(user)
    click_button 'フォローする'
    # お気に入りする
    visit root_path
    find('.like-icon').click
    # コメントする
    click_link surplus_land.title
    fill_in 'comment_body', with: 'example-comment.'
    click_button 'コメントする'
    # 申し込む（メッセージを送る）
    click_button '申し込む'
    # userで通知一覧を確認
    sign_out visitor
    sign_in user
    visit notifications_path
    expect(page).to have_content "#{visitor.name} があなたをフォローしました！"
    expect(page).to have_content "#{visitor.name} があなたのキャンプ地をお気に入りしました！"
    expect(page).to have_content "#{visitor.name} があなたのキャンプ地にコメントしました！"
    expect(page).to have_content "#{visitor.name} からメッセージが届いています！"
  end
end
