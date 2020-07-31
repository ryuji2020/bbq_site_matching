require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "returns http success" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users/sign_in' do
    let(:user) { create(:user) }

    before(:each) { post user_session_path, params: user_params }

    context 'login with valid information' do
      let(:user_params) { { user: { email: user.email, password: user.password } } }

      it 'successful login' do
        expect(response).to redirect_to root_path
      end
    end

    context 'login with invalid information' do
      let(:user_params) { { user: { email: 'wrong@address', password: 'wrongpass' } } }

      it 'login fails' do
        expect(response).to render_template 'new'
      end
    end
  end
end
