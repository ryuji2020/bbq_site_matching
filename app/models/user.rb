class User < ApplicationRecord
  has_many :surplus_lands, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_surplus_lands, through: :likes, source: :surplus_land
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :profile, length: { maximum: 400 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # surplus_landをお気に入りする
  def like(surplus_land)
    likes.create(surplus_land_id: surplus_land.id)
  end

  # userがsurplus_landをお気に入りしていればtrueを返す
  def like?(surplus_land)
    like_surplus_lands.include?(surplus_land)
  end
end
