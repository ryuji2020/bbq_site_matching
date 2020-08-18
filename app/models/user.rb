class User < ApplicationRecord
  has_many :surplus_lands, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_surplus_lands, through: :likes, source: :surplus_land
  has_many :active_relationships,
    class_name: 'Relationship',
    foreign_key: 'follower_id',
    dependent: :destroy
  has_many :passive_relationships,
    class_name: 'Relationship',
    foreign_key: 'followed_id',
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :comments, dependent: :destroy
  has_many :visit_rooms,
    class_name: 'Room',
    foreign_key: 'visitor_id'
  has_many :send_messages,
    class_name: 'Message',
    foreign_key: 'sender_id'
  has_many :receive_messages,
    class_name: 'Message',
    foreign_key: 'receiver_id'

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

  # other_userをフォローする
  def follow(other_user)
    following << other_user
  end

  # other_userをフォローをしていれはtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # other_userのフォローを解除する
  def unfollow(other_user)
    following.delete(other_user)
  end
end
