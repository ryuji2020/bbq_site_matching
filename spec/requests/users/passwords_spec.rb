require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  describe "GET /users/password/new" do
    it "returns http success" do
      get new_user_password_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users/password' do
    let(:user) { create(:user) }

    it 'send reset-password-mail' do
      post user_password_path, params: { user: { email: user.email } }
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end
end
