require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/space_repository'

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