class Room < ApplicationRecord
  belongs_to :surplus_land
  belongs_to :visitor, class_name: 'User'

  validates :surplus_land_id, presence: true
  validates :visitor_id, presence: true

  delegate :owner, to: :surplus_land
end
