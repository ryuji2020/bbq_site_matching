require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:profile).is_at_most(400) }

    it 'email validation should accept valid addresses' do
      valid_addresses = %w[
        user@example.com
        USER@foo.COM
        A_US-ER@foo.bar.org
        first.last@foo.jp
        alice+bob@baz.cn
      ]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to be true
      end
    end

    it 'email validation should reject invalid addresses' do
      invalid_addresses = %w[
        user@example,com
        user_at_foo.org
        user.name@example.
        foo@bar_baz.com
        foo@bar+baz.com
      ]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).to be false
      end
    end

    it 'email address should be unique' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user.valid?).to be false
    end
  end

  describe 'before save' do
    it 'email addresses should be saved as lower case' do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe 'associations' do
    it { should have_many(:surplus_lands).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:like_surplus_lands).through(:likes).source(:surplus_land) }
    it { should have_many(:active_relationships).class_name('Relationship').with_foreign_key('follower_id') }
    it { should have_many(:passive_relationships).class_name('Relationship').with_foreign_key('followed_id') }
    it { should have_many(:following).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships) }
    it { should have_many(:visit_rooms).class_name('Room').with_foreign_key('visitor_id').dependent(:destroy) }
    it { should have_many(:send_messages).class_name('Message').with_foreign_key('sender_id').dependent(:destroy) }
    it { should have_many(:active_notifications).class_name('Notification').with_foreign_key('visitor_id').dependent(:destroy) }
    it { should have_many(:passive_notifications).class_name('Notification').with_foreign_key('visited_id').dependent(:destroy) }
  end
end
