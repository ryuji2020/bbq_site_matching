require 'rails_helper'

RSpec.describe "SurplusLands", type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    it "returns http success" do
      get surplus_lands_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    context 'when user not sign in' do
      it 'redirect and request sign in' do
        get new_surplus_land_path(user)
        expect(response.body).to include 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when user signed in' do
      it 'returns http success' do
        sign_in user
        get new_surplus_land_path(user)
        expect(response).to have_http_status :success
      end
    end
  end

  describe 'POST /create' do
    before(:each) do
      sign_in user
      create(:prefecture)
    end

    context 'when params is invalid' do
      let(:params) do
        {
          surplus_land: {
            title: '',
            price: 'string',
            state: 'shinjuku',
            address: '',
            description: '',
          }
        }
      end

      it 'failed to create surplua_land' do
        expect do
          post surplus_lands_path, params: params
        end.not_to change(SurplusLand, :count)
        expect(response).to render_template 'new'
      end
    end

    context 'when params is valid' do
      let(:params) do
        {
          surplus_land: {
            title: 'title',
            price: 300,
            state: '東京都',
            address: '新宿区歌舞伎町1-2-3',
            description: 'valid description.',
          }
        }
      end

      it 'success to create surplus_land' do
        expect do
          post surplus_lands_path, params: params
        end.to change(SurplusLand, :count).by(1)
        expect(response).to redirect_to surplus_land_path(SurplusLand.last)
      end
    end
  end

  describe 'GET /edit' do
    let(:surplus_land) { create(:surplus_land, :with_prefecture, user: user) }

    context 'when not correct-user' do
      let(:other_user) { create(:user) }

      before(:each) { sign_in other_user }

      it 'redirect root url' do
        get edit_surplus_land_path(surplus_land)
        expect(response).to redirect_to root_url
      end
    end

    context 'when correct user' do
      before(:each) { sign_in user }

      it 'returns http success' do
        get edit_surplus_land_path(surplus_land)
        expect(response).to have_http_status :success
      end
    end
  end

  describe 'PATCH /update' do
    let(:surplus_land) { create(:surplus_land, :with_prefecture, title: 'old-title', user: user) }

    before(:each) { sign_in user }

    context 'when params is invalid' do
      let(:params) { { surplus_land: attributes_for(:surplus_land, title: '') } }

      it 'failed to update surplus_land' do
        expect do
          patch surplus_land_path(surplus_land), params: params
        end.not_to change { surplus_land.reload.title }
        expect(response).to render_template 'edit'
      end
    end

    context 'when params is valid' do
      let(:params) do
        {
          surplus_land: {
            title: 'new-title',
            images: [Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/valid-2.png'), 'image/png')],
          }
        }
      end
      let(:delete_image) { { surplus_land: { image_ids: surplus_land.images.map(&:id) } } }

      it 'success to update surplus_land' do
        # タイトルの変更、画像の追加に成功
        expect do
          patch surplus_land_path(surplus_land), params: params
        end.to change { surplus_land.reload.title }.from('old-title').to('new-title')
        expect(surplus_land.images.size).to eq 2
        # 画像の削除に成功
        expect do
          patch surplus_land_path(surplus_land), params: delete_image
        end.to change { surplus_land.reload.images.size }.from(2).to(0)
        # 正しくリダイレクトされる
        expect(response).to redirect_to surplus_land_path(surplus_land)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:surplus_land) { create(:surplus_land, :with_prefecture, user: user) }

    context 'when not correct-user' do
      let(:other_user) { create(:user) }

      before(:each) { sign_in other_user }

      it 'redirect root url' do
        delete surplus_land_path(surplus_land)
        expect(response).to redirect_to root_url
      end
    end

    context 'when signin correct user' do
      before(:each) { sign_in user }

      it 'successful destroy surplus_land' do
        expect do
          delete surplus_land_path(surplus_land)
        end.to change(SurplusLand, :count).by(-1)
        expect(response).to redirect_to root_url
      end
    end
  end
end
