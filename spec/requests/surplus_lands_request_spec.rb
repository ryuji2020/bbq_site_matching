require 'rails_helper'

RSpec.describe "SurplusLands", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/surplus_lands/index"
      expect(response).to have_http_status(:success)
    end
  end

end
