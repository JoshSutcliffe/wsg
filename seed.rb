require './db_config'
require './models/stadium'
require './models/user'
require './models/like'

Stadium.delete_all
User.delete_all
Like.delete_all

count = 1

file = File.open('elland_road.jpg')

5.times do
  Stadium.create(name: "Stadium #{count}", city: "City #{count}", country: "Country #{count}", clubs: "Clubs #{count}", pictures: file, bio: "")
  count += 1
end

User.create(username: "cakepudding", email: "cake@pudding.com", password: "cakepudding")

file.close