require 'active_record'
# require 'carrierwave/orm/activerecord'
# require 'carrierwave'

options = {
  adapter: 'postgresql',
  database: 'worldstadiums'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)