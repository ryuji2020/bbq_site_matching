class SurplusLand < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture, foreign_key: 'state', primary_key: 'name'
  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :state, presence: true
  validates :address, presence: true
  validates :description, presence: true, length: { maximum: 400 }
end
