class SurplusLand < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :state, presence: true
  validates :description, presence: true, length: { maximum: 400 }
end
