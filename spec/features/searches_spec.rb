require 'rails_helper'

RSpec.feature "Searchs", type: :feature do
  include PrefectureHelper

  background { save_prefecture }

  given(:user) { create(:user) }
  given!(:tokyo_land) { create(:surplus_land, user: user, title: 'BBQ') }
  given!(:kanagawa_land) { create(:surplus_land, user: user, title: 'camp', state: '神奈川県') }

  scenario 'refine search by prefecture' do
    visit surplus_lands_path
    expect(page).to have_content '貸し出し中のキャンプ地＆BBQ場'
    expect(page).to have_content tokyo_land.title
    expect(page).to have_content kanagawa_land.title
    click_link '北海道'
    expect(page).to have_content '北海道のキャンプ地はまだ登録されていません'
    click_link '東京都'
    expect(page).to have_content '東京都のキャンプ地＆BBQ場'
    expect(page).to have_content tokyo_land.title
    expect(page).to have_no_content kanagawa_land.title
  end

  scenario 'search by keyword' do
    visit root_path
    fill_in 'q_title_or_state_cont', with: 'BBQ'
    click_button '検索'
    expect(page).to have_content '「BBQ」の検索結果'
    expect(page).to have_content tokyo_land.title
    expect(page).to have_no_content kanagawa_land.title
    fill_in 'q_title_or_state_cont', with: '神奈川'
    click_button '検索'
    expect(page).to have_content '「神奈川」の検索結果'
    expect(page).to have_no_content tokyo_land.title
    expect(page).to have_content kanagawa_land.title
    fill_in 'q_title_or_state_cont', with: 'touring'
    click_button '検索'
    expect(page).to have_content '「touring」の検索結果'
    expect(page).to have_no_content tokyo_land.title
    expect(page).to have_no_content kanagawa_land.title
    expect(page).to have_content '「touring」の検索結果は見つかりませんでした'
  end
end
