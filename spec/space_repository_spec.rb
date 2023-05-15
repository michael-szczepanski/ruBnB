require 'space_repository'

RSpec.describe SpaceRepository do
  def reset_space_tables 
    seed_sql = File.read('spec/seeds_rubnb.sql')
    connection = PG.connect({host: '127.0.0.1', dbname: 'rubnb_test'})
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_space_tables
  end

  context 'The All Method' do
    it 'returns all the spaces' do
      repo = SpaceRepository.new
      spaces = repo.all

      expect(spaces.length).to eq 3
      expect(spaces.first.name).to eq "Jack's House"
      expect(spaces.last.name).to eq "Jill's converted well"
      expect(spaces.first.description).to eq "This is my lovely house"
      expect(spaces.first.price_per_night).to eq '10.5'
      expect(spaces.first.availability).to eq "true"
    end
  end
end