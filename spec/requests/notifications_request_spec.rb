require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "GET /notifications" do
    context 'when not user signed in' do
      it 'sign-in required' do
        get notifications_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      let(:user) { create(:user) }

      before(:each) { sign_in user }

      it "returns http success" do
        get notifications_path
        expect(response).to have_http_status :success
      end
    end
  end

  describe 'create-notifications' do
    let(:visitor) { create(:user) }
    let(:visited) { create(:user) }
    let(:other_user) { create(:user) }
    let(:surplus_land) { create(:surplus_land, :with_prefecture, user: visited) }
    let(:own_surplus_land) { create(:surplus_land, user: visitor) }
    let(:comment_params) { { comment: { body: 'Example-comment' } } }
    let(:message_params) { { message: { content: 'Example-message' } } }

    before(:each) { sign_in visitor }

    it 'create follow notification' do
      expect do
        post relationships_path, params: { followed_id: visited.id }
      end.to change(Notification, :count).by(1)
      expect(Notification.first.action).to eq 'follow'
      # フォローボタンを連打しても通知は一回のみ
      relationship = Relationship.find_by(follower_id: visitor.id, followed_id: visited.id)
      delete relationship_path(relationship)
      expect do
        post relationships_path, params: { followed_id: visited.id }
      end.not_to change(Notification, :count)
    end

    it 'create like notification' do
      expect do
        post surplus_land_likes_path(surplus_land)
      end.to change(Notification, :count).by(1)
      expect(Notification.first.action).to eq 'like'
      expect(Notification.first.checked).to be false
      # いいねボタンを連打しても通知は一回のみ
      like = Like.find_by(surplus_land_id: surplus_land.id, user_id: visitor.id)
      delete surplus_land_like_path(surplus_land, like)
      expect do
        post surplus_land_likes_path(surplus_land)
        sleep 1
      end.not_to change(Notification, :count)
      # 自分のsurplus_landへのいいねの時はcheckedがtrue
      expect do
        post surplus_land_likes_path(own_surplus_land)
        sleep 1
      end.to change(Notification, :count).by(1)
      expect(Notification.first.action).to eq 'like'
      expect(Notification.first.checked).to be true
    end

    it 'create comment notification' do
      expect do
        post surplus_land_comments_path(surplus_land), params: comment_params
      end.to change(Notification, :count).by(1)
      expect(Notification.first.action).to eq 'comment'
      expect(Notification.first.checked).to be false
      # other_userがコメントした時は先にコメントをしたユーザーとsurplus_landの所有者に通知が行く
      sign_out visitor
      sign_in other_user
      expect do
        post surplus_land_comments_path(surplus_land), params: comment_params
      end.to change(Notification, :count).by(2)
      expect(Notification.where(visitor_id: other_user.id).pluck(:visited_id)).to match_array [visited.id, visitor.id]
      expect(Notification.where(visitor_id: other_user.id).pluck(:checked)).to match [false, false]
      # 自分のsurplus_landにコメントした時、自分への通知は通知済みとなっている
      sign_out other_user
      sign_in visited
      expect do
        post surplus_land_comments_path(surplus_land), params: comment_params
      end.to change(Notification, :count).by(3)
      expect(Notification.where(visitor_id: visited.id).pluck(:visited_id)).to match_array [visited.id, visitor.id, other_user.id]
      expect(Notification.where(visitor_id: visited.id).pluck(:checked)).to match_array [true, false, false]
      expect(Notification.find_by(visitor_id: visited.id, visited_id: visited.id).checked).to be true
    end

    it 'create message notification' do
      expect do
        post rooms_path, params: { surplus_land_id: surplus_land.id } # messageは自動生成される
      end.to change(Notification, :count).by(1)
      expect(Notification.first.action).to eq 'message'
      room = Room.find_by(surplus_land_id: surplus_land.id, visitor_id: visitor.id)
      expect do
        post room_messages_path(room), params: message_params
      end.to change(Notification, :count).by(1)
      expect(Notification.first.visited).to eq visited
      sign_out visitor
      sign_in visited
      sleep 1
      expect do
        post room_messages_path(room), params: message_params
      end.to change(Notification, :count).by(1)
      expect(Notification.first.visited).to eq visitor
    end
  end
end
