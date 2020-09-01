require 'rails_helper'

RSpec.xdescribe Room, type: :model do
  describe 'validations' do
    it { should validate_presence_of :surplus_land_id }
    it { should validate_presence_of :visitor_id }
  end

  describe 'associations' do
    let(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }
    let(:visitor) { create(:user) }
    let(:room) { create(:room, surplus_land: surplus_land, visitor: visitor) }

    it { should belong_to :surplus_land }
    it { should belong_to(:visitor).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }

    it 'association could be called correctly' do
      expect(room.owner).to eq surplus_land.user
    end
  end
end
