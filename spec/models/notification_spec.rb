require 'rails_helper'

RSpec.describe Notification, type: :model do
  # describe 'validations' do
  #   it { should validate_presence_of :visitor_id }
  #   it { should validate_presence_of :visited_id }
  #   it { should validate_presence_of :action }
  # end
  #
  # describe 'associations' do
  #   it { should belong_to(:visitor).class_name('User') }
  #   it { should belong_to(:visited).class_name('User') }
  #
  #   describe 'belongs_to ..., optional:true' do
  #     let(:visitor) { create(:user) }
  #     let(:visited) { create(:user) }
  #     let(:surplus_land) { create(:surplus_land, :with_prefecture, user: visited) }
  #     let(:room) { create(:room, surplus_land: surplus_land, visitor: visitor) }
  #     let(:message) { create(:message, room: room, sender: visitor) }
  #     let(:comment) { create(:comment, user: visitor, surplus_land: surplus_land) }
  #     let(:notification) do
  #       create(:notification,
  #         visitor: visitor,
  #         visited: visited,
  #         surplus_land: surplus_land,
  #         room: room,
  #         message: message,
  #         comment: comment,
  #         action: 'action')
  #     end
  #
  #     it 'defined methods correctly' do
  #       expect(notification.surplus_land).to eq surplus_land
  #       expect(notification.room).to eq room
  #       expect(notification.message).to eq message
  #       expect(notification.comment).to eq comment
  #     end
  #   end
  # end
end
