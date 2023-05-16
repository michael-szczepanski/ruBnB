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
    redirect "/spaces"
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
    repo = SpaceRepository.new
    space = Space.new
    space.name = params[:name]
    space.description = params[:description]
    space.price_per_night = params[:price_per_night]
    space.availability = params[:availability] == "true" ? true : false
    space.user_id = 1

    repo.create(space)
    redirect('/spaces')
  end

  get '/spaces/:id' do
    repo = SpaceRepository.new
    @space = repo.find_by_id(params[:id])

    return erb(:space_view)
  end

  post '/book-a-space' do
    repo = SpaceRepository.new
    repo.book(params[:id])

    redirect "/spaces/#{params[:id]}"

  end
end