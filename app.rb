require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'bcrypt'
require 'sinatra/content_for'
require_relative 'lib/database_connection'
require_relative 'lib/space_repository'
require_relative 'lib/space'
require_relative 'lib/user_repository'
require_relative 'lib/user'
require_relative 'lib/booking_repository'

if ENV['ENV'] != 'test'
  DatabaseConnection.connect('rubnb')
end

class Application < Sinatra::Base
  enable :sessions
  helpers Sinatra::ContentFor

  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
    also_reload 'lib/space_repository'
    also_reload 'lib/user_repository'
  end

  get '/' do
    repo = SpaceRepository.new
    @top_spaces = repo.find_top_spaces
    @user_not_logged_in = session[:user] == nil
    return erb(:index)
  end

  get '/spaces' do
    repo = SpaceRepository.new
    @spaces = repo.all

    return erb(:spaces)
  end

  get '/my_spaces' do
    redirect '/login' if session[:user] == nil
    
    repo = SpaceRepository.new
    @spaces_by_user = repo.all_by_user(session[:user].id)
    return erb(:userpage)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    repo = UserRepository.new
    user = User.new
    username_valid = repo.is_username_unique?(params[:username])
    email_valid = repo.is_email_unique?(params[:email])
    if username_valid && email_valid
      user.id = params[:id].to_i
      user.name = params[:name]
      user.username = params[:username]
      user.email = params[:email]
      user.password = params[:password]
      repo.create(user)
      session[:user] = user
      redirect '/my_spaces'
    else
      flash[:username] = "Username already in use" unless username_valid
      flash[:email] = "Email already in use" unless email_valid
      redirect back
    end
  end

  get '/login' do
    erb(:login)
  end
  
  post '/login' do
    repo = UserRepository.new
    email = params[:email]
    password = params[:password]
    session[:user] = repo.log_in(email, password)
    if session[:user] == nil
      flash[:error] = "email/password incorrect"
      redirect back
    else
      redirect '/my_spaces'
    end
  end

  get '/logout' do
    session[:user] = nil
    redirect '/'
  end

  post '/logout' do
    session[:user] = nil
    redirect '/'
  end

  get '/spaces/new' do
    redirect '/login' if session[:user] == nil

    return erb(:spaces_new)
  end

  post '/spaces/new' do
    redirect '/login' if session[:user] == nil
    
    repo = SpaceRepository.new
    space = Space.new

    dates_valid = (Date.parse(params[:available_to]) >= Date.parse(params[:available_from]))
    
    if dates_valid

    space.name = params[:name]
    space.description = params[:description]
    space.price_per_night = params[:price_per_night]
    space.available_from = params[:available_from]
    space.available_to = params[:available_to]
    space.user_id = session[:user].id

    repo.create(space)
    redirect('/my_spaces')
    else
      flash[:dates_valid] = "Your space should be available for at least one night."
      redirect back
    end
  end

  get '/spaces/:id' do
    repo = SpaceRepository.new
    @space = repo.find_by_id(params[:id])
    @dates = repo.availability_status(params[:id])
    @user_id = session[:user].id if session[:user] != nil

    return erb(:space_view)
  end

  post '/book' do
    redirect '/login' if session[:user] == nil

    repo = BookingRepository.new
    repo.create(params[:date], params[:user_id], params[:space_id])

    redirect "/bookings"
  end

  get '/bookings' do
    redirect '/login' if session[:user] == nil

    booking_repo = BookingRepository.new
    @space_repo = SpaceRepository.new

    @user_bookings = booking_repo.find_by_user(session[:user].id)
    @space_bookings = booking_repo.find_for_user(session[:user].id)

    return erb(:bookings)
  end

  post '/confirm' do
    booking_repo = BookingRepository.new
    booking_repo.confirm(params[:id]) 

    redirect '/bookings'
  end

  post '/deny' do
    booking_repo = BookingRepository.new
    booking_repo.deny(params[:id]) 
    
    redirect '/bookings'
  end
end