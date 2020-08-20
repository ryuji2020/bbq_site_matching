class Notification < ApplicationRecord
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :surplus_land, optional: true
  belongs_to :room, optional: true
  belongs_to :message, optional: true
  belongs_to :comment, optional: true

  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  validates :action, presence: true

  default_scope -> { order(created_at: :desc) }
end
