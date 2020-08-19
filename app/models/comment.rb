class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :surplus_land
  has_many :notifications, dependent: :destroy

  validates :body, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true
  validates :surplus_land_id, presence: true
end
