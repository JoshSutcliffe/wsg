require './db_config'
require 'active_record'
require 'pry'
# require 'carrierwave/orm/activerecord'

%w{stadium user like}.each do |file|
  require "./models/#{file}"
end

# Use this page to test the database

binding.pry