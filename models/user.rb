class User < ActiveRecord::Base
  has_secure_password 
  has_many :likes
  has_many :stadia, through: :likes

  validates_uniqueness_of :email
  validates_uniqueness_of :username

  # mount_uploader :avatar, AvatarUploader
end