require 'rails_helper'

RSpec.describe SurplusLand, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }

    it { should validate_length_of(:title).is_at_most(50) }

    it { should validate_presence_of :price }

    it { should validate_presence_of :state }

    it { should validate_length_of(:description).is_at_most(400) }
  end

  describe 'association' do
    it { should belong_to :user }

    describe 'references prefecture' do
      let(:surplus_land) { build(:surplus_land, :with_user) }

      it 'state could save only valid value' do
        surplus_land.state = '東京'
        expect(surplus_land).to be_valid
        surplus_land.state = '新宿'
        expect(surplus_land).not_to be_valid
      end
    end
  end
end
