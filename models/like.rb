class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :stadia

  # mount_uploader :avatar, AvatarUploader
end