require 'rails_helper'

RSpec.feature "SurplusLands", type: :feature do
  background do
    create(:prefecture)
    create(:prefecture, name: '神奈川県')
    create(:prefecture, name: '長野県')
  end

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:tokyo_surplus_lands) { create_list(:surplus_land, 4, state: '東京都', user: user) }
  given!(:kanagawa_surplus_lands) { create_list(:surplus_land, 4, state: '神奈川県', user: user) }
  given!(:nagano_surplus_lands) { create_list(:surplus_land, 4, state: '長野県', user: user) }
  given!(:last_create_land) { create(:surplus_land, state: '東京都', user: user, created_at: Time.current + 60) }
  given!(:first_create_land) { create(:surplus_land, state: '東京都', user: other_user, created_at: Time.current - 60) }

  scenario 'surplus_lands displayed correctly' do
    visit root_path
    expect(page).to have_link '一覧から探す', href: surplus_lands_path
    # default_scopeにより新しい順に並び替わっている
    expect(SurplusLand.first).to eq last_create_land
    # 最近追加されたキャンプ地が４件表示されている
    expect(page).to have_content SurplusLand.first.title
    expect(page).to have_content SurplusLand.second.title
    expect(page).to have_content SurplusLand.third.title
    expect(page).to have_content SurplusLand.fourth.title
    expect(page).to have_no_content SurplusLand.fifth.title
    # clickすると詳細ページへ行く
    click_on last_create_land.title
    expect(current_path).to eq surplus_land_path(last_create_land)
    # 一覧ページでは12件ずつ表示されている
    visit root_path
    click_link '一覧から探す'
    expect(current_path).to eq surplus_lands_path
    surplus_lands = SurplusLand.all
    expect(page).to have_content surplus_lands[0].title
    expect(page).to have_content surplus_lands[11].title
    expect(page).to have_no_content first_create_land.title
    # 都道府県サイドバーで絞り込める
    # サイドバーにprefectureモデルを使っているため画面操作が難しいのでvisitを使用
    visit refine_search_surplus_land_path('東京都')
    expect(page).to have_content tokyo_surplus_lands.first.title
    expect(page).to have_content tokyo_surplus_lands.second.title
    expect(page).to have_content tokyo_surplus_lands.last.title
    expect(page).to have_no_content kanagawa_surplus_lands.first.title
    expect(page).to have_no_content nagano_surplus_lands.first.title
    # clickすると詳細ページへ行く
    click_on last_create_land.title
    expect(current_path).to eq surplus_land_path(last_create_land)
    # ログインしてないときは編集ページへのリンクがない
    expect(page).to have_no_link '編集する'
    # 違うユーザーのときは編集ページへのリンクがない
    sign_in other_user
    visit surplus_land_path(last_create_land)
    expect(page).to have_no_link '編集する'
    # 自分のキャンプ地のときは編集ページへのリンクがある
    click_link 'ログアウト'
    sign_in user
    visit surplus_land_path(last_create_land)
    expect(page).to have_link '編集する', href: edit_surplus_land_path(last_create_land)
  end
end
