require 'space_repository'
require 'space'

RSpec.describe SpaceRepository do

  def reset_spaces_table
    seed_sql = File.read('spec/seeds_rubnb.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'rubnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_spaces_table
  end

  context '#create(space)' do
    it 'creates a new single space' do
      
      new_space = Space.new
      repo = SpaceRepository.new

      new_space.name = 'The Moon'
      new_space.description = 'made of cheese'
      new_space.price_per_night = 2.99
      new_space.availability = true
      new_space.user_id = 2

      response = repo.create(new_space)

      expect(response[0]['id']).to eq "4"

    end
  end

end