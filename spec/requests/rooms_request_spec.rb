require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }
  let(:visitor) { create(:user) }

  describe 'GET /rooms/:id' do
    let(:room) { create(:room, surplus_land: surplus_land, visitor: visitor) }

    context 'when not user signed in' do
      it 'ridirect to sign-in-page' do
        get room_path(room)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'sign in with unrelated user' do
        let(:other_user) { create(:user) }

        before(:each) { sign_in other_user }

        it 'can not enter the talk room' do
          get room_path(room)
          expect(response).to redirect_to root_url
        end
      end

      context 'sign in with surplus_land.user(room.owner)' do
        before(:each) { sign_in room.owner }

        it 'returs http success' do
          get room_path(room)
          expect(response).to have_http_status :success
        end
      end

      context 'sign in with visitor' do
        before(:each) { sign_in room.visitor }

        it 'returns http success' do
          get room_path(room)
          expect(response).to have_http_status :success
        end
      end
    end
  end

  describe 'POST /rooms' do
    let(:params) { { surplus_land_id: surplus_land.id } }

    context 'when not user signed in' do
      it 'can not create talk-room' do
        expect do
          post rooms_path, params: params
        end.not_to change(Room, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'sign in with surplus_land.user' do
        before(:each) { sign_in surplus_land.user }

        it 'can not create talk-room(can not apply to own surplus_land)' do
          expect do
            post rooms_path, params: params
          end.not_to change(Room, :count)
          expect(response).to redirect_to root_url
        end
      end

      context 'sign in with other than surplus_land.user' do
        before(:each) { sign_in visitor }

        it 'created the talk-room(success to apply)' do
          expect do
            post rooms_path, params: params
          end.to change(Room, :count).by(1)
          expect(response).to redirect_to room_path(Room.last)
        end
      end
    end
  end
end
