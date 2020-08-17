class Room < ApplicationRecord
  belongs_to :surplus_land
  belongs_to :visitor, class_name: 'User'

  delegate :owner, to: :surplus_land
end
