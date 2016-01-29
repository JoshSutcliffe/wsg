require 'pg'     
require 'sinatra'
require './db_config'

%w{stadium user like}.each do |file|
  require "./models/#{file}"
end

configure :development do |c|
  require 'pry'
  require 'sinatra/reloader'
end

enable :sessions


helpers do

  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def liked?(current_stadium)
    if logged_in? 
      !!current_user.likes.find_by(stadium_id: current_stadium)
    end
  end

  def current_user_name
    User.find_by(id: session[:user_id]).username
  end

end

# Homepage
get '/' do
  @stadia = Stadium.all 
  erb :index
end

# New stadiums page
get '/stadium/new' do
  # @stadium = Stadium.new
  erb :new
end

# Add a stadium
post '/stadium/new' do
  
  if logged_in?
    @stadium = Stadium.new
    @stadium.name = params[:name]
    @stadium.city = params[:city]
    @stadium.country = params[:country]
    @stadium.clubs = params[:clubs]
    @stadium.pictures = params[:pictures]
    @stadium.capacity = params[:capacity]
    @stadium.bio = params[:bio]
    if @stadium.save
      redirect to '/'
    else
      erb :new
    end

  else
    erb :login
  end

end

# Show selected stadium
get '/stadium/:id' do

  @selected_stadium = Stadium.find(params[:id])
  erb :show

end

# Edit stadium
get '/stadium/:id/edit' do

  @edit = Stadium.find(params[:id])
  erb :edit

end

# Update a stadium
put '/stadium/:id' do

  if logged_in?
    @stadium = Stadium.find(params[:id])
    @stadium.city = params[:city]
    @stadium.country = params[:country]
    @stadium.clubs = params[:clubs]
    @stadium.pictures = params[:pictures]
    @stadium.capacity = params[:capacity]
    @stadium.bio = params[:bio]
      if @stadium.save
        redirect to "/stadium/#{ params[:id] }"
      else
        @edit = Stadium.find(params[:id])
        erb :edit
      end
  
  else
    erb :login
  end

end

# Adding a like
post '/likes' do

  like = Like.new # This creates the new like in the db
  if logged_in?
    like.user_id = current_user.id 
    like.stadium_id = params[:stadium_id]
    like.save
    redirect back
  else
    erb :login
  end

end

# Deleting a like
delete '/likes' do

  likes = Like.where(user_id: current_user.id, stadium_id: params[:stadium_id])
  likes.each do |like|
    like.destroy
  end

  redirect back

end

# Authentication =========================

# Login button
get '/session/new' do
  erb :login
end

# Go to create account page from login
get '/create_account' do
  erb :create_account
end

# Create new account
post '/session/create_account' do

  @user = User.new
  @user.username = params[:username]
  @user.email = params[:email]
  @user.password = params[:password]
  if @user.save
    user = User.find_by(email: params[:email])
    # When creating an ccount you are automatically logged in below
    if @user.email && user.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect to home page
      redirect to '/'
    end
  else
    # Shows error message on login page
    erb :create_account
  end

end

# logging in from login page
post '/session' do
  # Serach for user
  user = User.find_by(email: params[:email])
  # Authenticate the password
  if user && user.authenticate(params[:password])
    # create a session
    session[:user_id] = user.id
    # redirect to homepage
    redirect to '/'
  else
    # stay on the login form for now
    erb :login
  end
end

# logout
delete '/session' do
  session[:user_id] = nil
  redirect to '/'
end







