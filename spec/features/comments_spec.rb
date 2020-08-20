require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  given(:user) { create(:user) }
  given(:surplus_land) { create(:surplus_land, state: '東京都', user: user) }

  background { create(:prefecture) }

  feature 'POST /surplus_lands/:surplus_land_id/comments', js: true do
    scenario 'create comments' do
      # ゲストユーザーではコメントできない
      visit surplus_land_path(surplus_land)
      fill_in 'comment_body', with: 'Example_Comment'
      click_button 'コメントする'
      expect(page).to have_content 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(Comment.count).to eq 0
      # userでサインイン
      sign_in user
      visit surplus_land_path(surplus_land)
      # コメントが空白
      click_button 'コメントする'
      expect(page).to have_content '400字以内でコメントを入力してください'
      expect(Comment.count).to eq 0
      # コメントが400字以上
      fill_in 'comment_body', with: 'comment' * 58
      click_button 'コメントする'
      expect(page).to have_content '400字以内でコメントを入力してください'
      expect(Comment.count).to eq 0
      # 有効なコメント
      fill_in 'comment_body', with: 'Valid_Comment'
      click_button 'コメントする'
      expect(page).to have_no_content '400字以内でコメントを入力してください'
      expect(page).to have_content 'Valid_Comment'
      expect(Comment.count).to eq 1
    end
  end

  feature 'DELETE /surplus_lands/:surplus_land_id/comments/:id', js: true do
    given(:other_user) { create(:user) }
    given!(:comment) { create(:comment, body: 'Example_Comment', user: user, surplus_land: surplus_land) }

    scenario 'delete comments' do
      # ゲストユーザー
      visit surplus_land_path(surplus_land)
      expect(page).to have_content 'Example_Comment'
      expect(page).to have_no_link '削除'
      # コメントしたユーザーとは違うユーザーでサインイン
      sign_in other_user
      visit surplus_land_path(surplus_land)
      expect(page).to have_content 'Example_Comment'
      expect(page).to have_no_link '削除'
      # コメントをしたユーザーでサインイン
      click_link other_user.name
      click_link 'ログアウト'
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit surplus_land_path(surplus_land)
      expect(page).to have_content 'Example_Comment'
      expect(page).to have_link '削除', href: surplus_land_comment_path(surplus_land, comment)
      click_link '削除'
      page.driver.browser.switch_to.alert.dismiss
      expect(Comment.count).to eq 1
      click_link '削除'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content 'Example_Comment'
      expect(page).to have_no_link '削除'
      expect(Comment.count).to eq 0
    end
  end
end
