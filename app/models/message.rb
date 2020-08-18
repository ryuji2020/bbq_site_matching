class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :content, presence: true, length: { maximum: 140 }
  validates :room_id, presence: true
  validates :sender_id, presence: true
end
