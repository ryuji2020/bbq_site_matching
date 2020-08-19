class Notification < ApplicationRecord
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :surplus_land, optional: true
  belongs_to :room, optional: true

  default_scope -> { order(created_at: :desc) }
end
