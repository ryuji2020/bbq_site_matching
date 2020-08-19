class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :surplus_land
  has_many :notifications, dependent: :destroy

  validates :body, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true
  validates :surplus_land_id, presence: true

  def create_notification(current_user)
    surplus_land = self.surplus_land
    owner_and_comment_user_ids = Comment.where(surplus_land_id: surplus_land.id).where.not(user_id: current_user.id).pluck(:user_id).uniq
    owner_and_comment_user_ids << surplus_land.user_id unless owner_and_comment_user_ids.include?(surplus_land.user_id)
    owner_and_comment_user_ids.each do |visited_id|
      notification = current_user.active_notifications.build(
        visited_id: visited_id,
        surplus_land_id: surplus_land.id,
        comment_id: id,
        action: 'comment'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
