require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/space_repository'
require_relative 'lib/space'

if ENV['ENV'] != 'test'
  DatabaseConnection.connect('rubnb')
end

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
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
    return "space added"
  end
end