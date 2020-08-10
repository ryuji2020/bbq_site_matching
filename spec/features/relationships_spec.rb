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
      # Relationshipモデルにレコードが2つあることを確認
      expect(Relationship.count).to eq 2
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
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_button 'フォローする'
      expect(page).to have_link '0 フォロワー', href: followers_user_path(other_user)
      expect(Relationship.count).to eq 1
    end
  end

  feature 'get /users/:id/following(followers)', js:true do
    given(:third_user) { create(:user) }

    background do
      create(:relationship, follower: user, followed: third_user)
      create(:relationship, follower: third_user, followed: user)
      create(:relationship, follower: other_user, followed: third_user)
      create(:relationship, follower: third_user, followed: other_user)
    end

    scenario 'show follow button in each user' do
      # Relationshipモデルにレコードが6つあることを確認
      expect(Relationship.count).to eq 6
      # ゲストユーザー
      visit following_user_path(user)
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_no_link '編集する'
      expect(page).to have_link '2 フォロー中', href: following_user_path(user)
      expect(page).to have_link '2 フォロワー', href: followers_user_path(user)
      # userでサインイン
      sign_in user
      # 自分のフォロワー（フォロー中）ページ
      visit user_path(user)
      click_link '2 フォロワー', href: followers_user_path(user)
      expect(page).to have_link '編集する', href: edit_user_registration_path
      expect(page).to have_button 'フォロー中', count: 2
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_link '2 フォロー中'
      expect(page).to have_link '2 フォロワー'
      within "#follow_form_#{other_user.id}" do
        click_button 'フォロー中'
      end
      expect(page).to have_button 'フォロー中', count: 1
      expect(page).to have_button 'フォローする', count: 1
      expect(page).to have_link '1 フォロー中'
      expect(page).to have_link '2 フォロワー'
      expect(Relationship.count).to eq 5
      expect(user.following?(other_user)).to be false
      # third_userのフォロー中（フォロワー）ページ
      click_link third_user.name, match: :first
      expect(current_path).to eq user_path(third_user)
      click_link '2 フォロー中'
      expect(page).to have_no_button 'フォロー中'
      expect(page).to have_button 'フォローする'
      expect(page).to have_link '編集する'
      expect(page).to have_link '2 フォロー中'
      expect(page).to have_link '2 フォロワー'
      within "#follow_form_#{other_user.id}" do
        click_button 'フォローする'
      end
      expect(page).to have_button 'フォロー中'
      expect(page).to have_no_button 'フォローする'
      expect(page).to have_link '2 フォロー中'
      expect(page).to have_link '2 フォロワー'
      expect(Relationship.count).to eq 6
      expect(user.following?(other_user)).to be true
    end
  end
end
