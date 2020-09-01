require 'rails_helper'

RSpec.describe Relationship, type: :model do
  # let(:user) { create(:user) }
  # let(:michael) { create(:user, name: 'Michael') }
  #
  # before(:each) { create(:relationship, follower: user, followed: michael) }
  #
  # describe 'validations' do
  #   it { should validate_presence_of :follower_id }
  #   it { should validate_presence_of :followed_id }
  #
  #   it 'follower_id and followed_id combination is uniqueness' do
  #     invalid_relationship = user.active_relationships.build(followed_id: michael.id)
  #     expect { invalid_relationship.save }.not_to change(Relationship, :count)
  #     new_relationship = user.passive_relationships.build(follower_id: michael.id)
  #     expect { new_relationship.save }.to change(Relationship, :count).by(1)
  #   end
  # end
  #
  # describe 'associations' do
  #   it { should belong_to(:follower).class_name('User') }
  #   it { should belong_to(:followed).class_name('User') }
  # end
end
