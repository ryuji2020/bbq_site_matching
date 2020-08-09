require 'rails_helper'

RSpec.feature "Relationships", type: :feature do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }

  background do
    create(:relationship, follower: user, followed: other_user)
    create(:relationship, follower: other_user, followed: user)
  end

  feature 'get /users/:id', js: true do
    scenario 'show follow-button and stats' do
      # ゲストユーザー
      visit user_path(user)
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_no_link '編集する'
      expect(page).to have_link '1 フォロー中', href: following_user_path(user)
      expect(page).to have_link '1 フォロワー', href: followers_user_path(user)
      # userでサインイン
      sign_in user
      # 自分のプロフィールページ
      visit user_path(user)
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_link '編集する', href: edit_user_registration_path
      expect(page).to have_link '1 フォロー中', href: following_user_path(user)
      expect(page).to have_link '1 フォロワー', href: followers_user_path(user)
      # 違うユーザーのプロフィールページ
      visit user_path(other_user)
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_button 'フォロー中'
      expect(page).to have_no_link '編集する'
      expect(page).to have_link '1 フォロー中', href: following_user_path(other_user)
      expect(page).to have_link '1 フォロワー', href: followers_user_path(other_user)
      click_button 'フォロー中'
      visit current_path
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_button 'フォローする'
      expect(page).to have_link '0 フォロワー', href: followers_user_path(other_user)
      ecpect(Relationship.count).to eq 1
    end
  end
end
