class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender, class_name: 'User'
  has_many :notifications, dependent: :destroy

  validates :content, presence: true, length: { maximum: 140 }
  validates :room_id, presence: true
  validates :sender_id, presence: true

  # 通知作成
  def create_notification(current_user)
    room = self.room
    visited_id = current_user == room.visitor ? room.owner.id : room.visitor_id
    notification = current_user.active_notifications.build(
      visited_id: visited_id,
      room_id: room.id,
      message_id: id,
      action: 'message'
    )
    notification.save if notification.valid?
  end
end
