require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :surplus_land_id }
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_most(400) }
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :surplus_land }
    it { should have_many(:notifications).dependent(:destroy) }
  end
end
