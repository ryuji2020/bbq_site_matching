class SurplusLand < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  belongs_to :prefecture, foreign_key: 'state', primary_key: 'name'
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :state, presence: true
  validates :address, presence: true
  validates :description, presence: true, length: { maximum: 400 }
  validates :images, blob: {
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size_range: 1..5.megabytes
  }

  default_scope -> { order(created_at: :desc) }
  attr_accessor :image_ids
  paginates_per 12

  # resize images
  def square_thumb
    images.first.variant(
      combine_options: {
        gravity: :center,
        resize: "230x230^",
        crop: "230x230+0+0"
      }
    ).processed
  end
end
