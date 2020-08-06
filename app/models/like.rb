class Like < ApplicationRecord
  belongs_to :surplus_land
  belongs_to :user
  validates :surplus_land_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end
