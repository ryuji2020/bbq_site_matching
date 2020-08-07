require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:surplus_land) { create(:surplus_land, :with_prefecture, user: user) }

  before(:each) { create(:like, surplus_land: surplus_land, user: user) }

  describe 'validations' do
    it { should validate_presence_of(:user_id) }

    it { should validate_presence_of(:surplus_land_id) }

    it 'surplus_land_id is uniqueness within the scope of user_id' do
      invalid_like = Like.new(surplus_land_id: surplus_land.id, user_id: user.id)
      expect(invalid_like).not_to be_valid
      valid_like = Like.new(surplus_land_id: surplus_land.id, user_id: other_user.id)
      expect(valid_like).to be_valid
    end
  end

  describe 'association' do
    it { should belong_to :user }

    it { should belong_to :surplus_land }

    it 'destroyed dependent to user' do
      expect { user.destroy }.to change(Like, :count).by(-1)
    end

    it 'destroyed dependent to surplus_land' do
      expect { surplus_land.destroy }.to change(Like, :count).by(-1)
    end
  end
end
