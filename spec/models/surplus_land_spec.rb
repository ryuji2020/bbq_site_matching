require 'rails_helper'

RSpec.describe SurplusLand, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_length_of(:title).is_at_most(50) }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :state }
    it { should validate_presence_of :address }
    it { should validate_presence_of :description }
    it { should validate_length_of(:description).is_at_most(400) }

    describe 'active-storatge validation' do
      context 'when image-file size < 5MB' do
        let(:surplus_land) { build(:surplus_land, :with_prefecture, :with_user) }

        it 'be valid' do
          expect(surplus_land).to be_valid
        end
      end

      context 'when image-file size > 5MB' do
        let(:surplus_land) do
          build(
            :surplus_land,
            :with_prefecture,
            :with_user,
            images: [Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/oversize.jpg'), 'image/jpg')]
          )
        end

        it 'not be valid' do
          expect(surplus_land).not_to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to(:prefecture).with_foreign_key('state').with_primary_key('name') }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:like_users).through(:likes).source(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:rooms).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }

    describe 'references prefecture' do
      let(:surplus_land) { create(:surplus_land, :with_prefecture, :with_user) }

      it 'state could save only valid value' do
        expect(surplus_land.state).to eq '東京都'
        expect(SurplusLand.count).to eq 1
        surplus_land.state = '新宿'
        expect(surplus_land).not_to be_valid
      end
    end
  end
end
