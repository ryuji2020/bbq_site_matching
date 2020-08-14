class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :surplus_land

  validates :body, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true
  validates :surplus_land_id, presence: true
end
