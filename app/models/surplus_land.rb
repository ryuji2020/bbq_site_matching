class SurplusLand < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture, foreign_key: 'state', primary_key: 'name'
  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :state, presence: true
  validates :description, presence: true, length: { maximum: 400 }
end
