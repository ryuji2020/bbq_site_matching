require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  describe "GET /users/passwords" do
    it "works! (now write some real specs)" do
      get users_passwords_index_path
      expect(response).to have_http_status(200)
    end
  end
end
