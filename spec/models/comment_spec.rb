require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of :user_id }

    it { should validate_presence_of :surplus_land_id }

    it { should validate_presence_of :body }

    it { should validate_length_of(:body).is_at_most(400) }
  end

  describe 'association' do
    let(:surplus_land_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:surplus_land) { create(:surplus_land, state: '東京都', user: surplus_land_user) }

    before(:each) do
      create(:prefecture)
      create(:comment, user: comment_user, surplus_land: surplus_land)
    end

    it 'destroyed dependent to surplus_land_user' do
      expect { surplus_land_user.destroy }.to change(Comment, :count).by(-1)
    end

    it 'destroyed dependent to comment_user' do
      expect { comment_user.destroy }.to change(Comment, :count).by(-1)
    end

    it 'destroyed dependent to surplus_land' do
      expect { surplus_land.destroy }.to change(Comment, :count).by(-1)
    end
  end
end
