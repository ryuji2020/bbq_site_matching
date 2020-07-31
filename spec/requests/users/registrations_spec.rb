require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "returns htttp success" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    context 'with valid information' do
      let(:user_params) { { user: attributes_for(:user) } }

      it 'success to create a new user' do
        expect do
          post user_registration_path, params: user_params
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid information' do
      let(:user_params) { { user: {
        name: 'Invalid User',
        email: 'invalidaddress',
        password: 'pass',
      } } }

      it 'failed to create a new user' do
        expect do
          post user_registration_path, params: user_params
        end.not_to change(User, :count)
      end
    end
  end

  describe 'GET /users/edit' do
    let(:user) { create(:user) }

    before(:each) { sign_in user }

    it 'returns http success' do
      get edit_user_registration_path
      expect(response).to have_http_status :success
    end
  end

  describe 'PUT /users' do
    let(:user) { create(:user) }

    before(:each) { sign_in user }

    it 'success to update user information' do
      put user_registration_path, params: { user: {
        name: 'Change Name',
        email: 'change@example.com',
        gender: 'male',
        profile: 'hello, i am Change.',
        current_password: 'password',
      } }
      expect(user.reload.name).to eq 'Change Name'
      expect(user.reload.email).to eq 'change@example.com'
      expect(user.reload.gender).to eq 'male'
      expect(user.reload.profile).to eq 'hello, i am Change.'
    end
  end

  describe 'DELETE /users' do
    let(:user) { create(:user) }

    before(:each) { sign_in user }

    it 'success to delete user' do
      expect do
        delete user_registration_path
      end.to change(User, :count).by(-1)
    end
  end
end
