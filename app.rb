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
    if session[:user] == nil
      return erb(:index)
    else
      @spaces_by_user = repo.all_by_user(session[:user])
      return erb(:userpage)
    end
  end

  get '/spaces' do
    repo = SpaceRepository.new
    @spaces = repo.all

    return erb(:spaces)
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
      redirect '/'
    else
      flash[:username] = "Username already in use" unless username_valid
      flash[:email] = "Email alread in use" unless email_valid
      redirect '/signup'
    end
  end

  post '/login' do
    repo = UserRepository.new
    email = params[:email]
    password = params[:password]
    session[:user] = repo.log_in(email, password)
    flash[:error] = "email/password incorrect" if session[:user] == nil
    redirect '/'
  end

  post '/logout' do
    session[:user] = nil
    redirect '/'
  end

  get '/spaces/new' do
    return erb(:spaces_new)
  end

  post '/spaces/new' do

    # if session[:user] == nil
    #   redirect '/'
    # end

    repo = SpaceRepository.new
    space = Space.new
    space.name = params[:name]
    space.description = params[:description]
    space.price_per_night = params[:price_per_night]
    space.user_id = session[:user].id

    repo.create(space)
    redirect('/spaces')
  end

  get '/spaces/:id' do
    repo = SpaceRepository.new
    @space = repo.find_by_id(params[:id])
    @dates = repo.availability_status(params[:id])

    return erb(:space_view)
  end

  post '/book-a-space' do
    repo = SpaceRepository.new
    repo.book(params[:id])

    redirect "/spaces/#{params[:id]}"

  end

  get '/bookings' do
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