require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:id" do
    it "returns http success" do
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/:id/following' do
    it 'returns http success' do
      get following_user_path(user)
      expect(response).to have_http_status :success
    end
  end

  describe 'GET /users/:id/followers' do
    it 'returns http success' do
      get followers_user_path(user)
      expect(response).to have_http_status :success
    end
  end
end
