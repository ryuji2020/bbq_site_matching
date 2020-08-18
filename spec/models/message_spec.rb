require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of :content }
    it { should validate_length_of(:content).is_at_most(140) }
    it { should validate_presence_of :room_id }
    it { should validate_presence_of :sender_id }
  end

  describe 'association' do
    it { should belong_to :room }
    it { should belong_to :sender }
  end
end
