require 'rails_helper'

RSpec.xdescribe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:surplus_land) { create(:surplus_land, state: '東京都', user: user) }
  let(:other_user_surplus_land) { create(:surplus_land, state: '東京都', user: other_user) }

  before(:each) { create(:prefecture) }

  describe 'POST /surplus_lands/:surplus_land_id/likes' do
    context 'when user not signed in' do
      it 'could not Likes to surplus_land' do
        expect do
          post surplus_land_likes_path(surplus_land)
        end.not_to change(Like, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      before(:each) { sign_in user }

      it 'could create Likes to surplus_land including own' do
        expect do
          post surplus_land_likes_path(other_user_surplus_land)
        end.to change(Like, :count).by(1)
        expect(Like.last.surplus_land_id).to eq other_user_surplus_land.id
        expect(Like.last.user_id).to eq user.id
        expect do
          post surplus_land_likes_path(surplus_land)
        end.to change(Like, :count).by(1)
        expect(Like.last.surplus_land_id).to eq surplus_land.id
        expect(Like.last.user_id).to eq user.id
      end
    end
  end

  describe 'DELETE /surplus_lands/:surplus_land_id/likes/:id' do
    let!(:like) { create(:like, surplus_land: surplus_land, user: user) }

    context 'when user not signed in' do
      it 'could not delete Likes' do
        expect do
          delete surplus_land_like_path(surplus_land, like)
        end.not_to change(Like, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'when not correct user' do
        before(:each) { sign_in other_user }

        it 'could not delete Likes' do
          expect do
            delete surplus_land_like_path(surplus_land, like)
          end.not_to change(Like, :count)
          expect(response).to redirect_to root_url
        end
      end

      context 'when correct user' do
        before(:each) { sign_in user }

        it 'user delete Likes' do
          expect do
            delete surplus_land_like_path(surplus_land, like)
          end.to change(Like, :count).by(-1)
        end
      end
    end
  end
end
