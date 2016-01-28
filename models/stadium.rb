require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    #
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder

    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => 'ap-southeast-2',
    :host   => 's3-ap-southeast-2.amazonaws.com'
  }

  # config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku

  config.storage = :fog

  config.fog_directory    = 'sutcliffestadiums'
end

class PicturesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [3264, 1800]
end

class Stadium < ActiveRecord::Base
  has_many :likes
  has_many :users, through: :likes

  validates_uniqueness_of :name
  validates_presence_of :city
  validates_presence_of :pictures, length: { minimum: 2 }
  validates_presence_of :country
  validates_presence_of :clubs

  mount_uploader :pictures, PicturesUploader
  # belongs_to :stadia
  # has_many :likes

end