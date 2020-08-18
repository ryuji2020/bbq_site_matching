require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }
  let(:visitor) { create(:user) }
  let(:room) { create(:room, surplus_land: surplus_land, visitor: visitor) }

  describe 'POST /rooms/:room_id/messages' do
    let(:params) { { message: { content: 'Example-message' } } } # receiver_idに関しては不要になるかもなのでいったんテストは書かない
    
    context 'when not user signed in' do
      it 'not created a message' do
        expect do
          post room_messages_path(room), params: params
        end.not_to change(Message, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'sign in with owner' do
        before(:each) { sign_in room.owner }

        it 'success to create a message' do
          expect do
            post room_messages_path(room), params: params
          end.to change(Message, :count).by(1)
          expect(Message.last.sender).to eq room.owner
        end
      end

      context 'sign in with visitor' do
        before(:each) { sign_in visitor }

        it 'success to create a message' do
          expect do
            post room_messages_path(room), params: params
          end.to change(Message, :count).by(1)
          expect(Message.last.sender).to eq visitor
        end
      end
    end
  end

  describe 'DELETE /rooms/:room_id/messages/:id' do
    let!(:message) { create(:message, room: room, sender: visitor) }

    context 'when not user signed in' do
      it 'not deleted message' do
        expect do
          delete room_message_path(room, message)
        end.not_to change(Message, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'sign in with owner(message-receiver)' do
        before(:each) { sign_in room.owner }

        it 'can not delete the message' do
          expect do
            delete room_message_path(room, message)
          end.not_to change(Message, :count)
          expect(response).to redirect_to root_url
        end
      end

      context 'sign in with visitor(message-sender)' do
        before(:each) { sign_in visitor }

        it 'success to delete the message' do
          expect do
            delete room_message_path(room, message)
          end.to change(Message, :count).by(-1)
          expect(response).to redirect_to room_path(room)
        end
      end
    end
  end
end
