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
  end
end
