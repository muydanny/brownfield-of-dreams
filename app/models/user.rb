class User < ApplicationRecord
  has_many :user_videos, dependent: :destroy
  has_many :videos, through: :user_videos


  # has_many :user_followers
  # has_many :user_followings
  # has_many :followers, through: :user_followers, foreign_key: :followee_id
  # has_many :following, through: :user_followings, foreign_key: :following_id

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
  validates :first_name, presence: true
  enum role: { default: 0, admin: 1 }
  has_secure_password
end 

# TODO write model tests for followers and followees