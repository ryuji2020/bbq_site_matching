require 'rails_helper'

RSpec.describe SurplusLand, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }

    it { should validate_length_of(:title).is_at_most(50) }

    it { should validate_presence_of :price }

    it { should validate_numericality_of(:price).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_presence_of :state }

    it { should validate_presence_of :address }

    it { should validate_length_of(:description).is_at_most(400) }
  end

  describe 'association' do
    it { should belong_to :user }

    describe 'references prefecture' do
      let(:surplus_land) { create(:surplus_land, :with_user) }

      it 'state could save only valid value' do
        expect(surplus_land.state).to eq '東京都'
        expect(SurplusLand.count).to eq 1
        surplus_land.state = '新宿'
        expect(surplus_land).not_to be_valid
      end
    end
  end
end
