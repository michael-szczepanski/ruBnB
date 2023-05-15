require 'space_repository'


def reset_tables
  seed_sql = File.read('spec/seeds_rubnb.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'rubnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe SpaceRepository do
  before(:each) do
    reset_tables
  end

  context 'READ' do
    it 'finds a space by ID' do
      repo = SpaceRepository.new
      
      space = repo.find_by_id(1)

      expect(space.id).to eq 1
      expect(space.name).to eq "Jack's House"
      expect(space.description).to eq "This is my lovely house"
      expect(space.price_per_night).to eq 10.5
      expect(space.availability).to eq 'true'
      expect(space.user_id).to eq 1

      space = repo.find_by_id(2)
      
      expect(space.id).to eq 2
      expect(space.name).to eq "Jack's Shed"
      expect(space.description).to eq "This is my less-lovely shed"
      expect(space.price_per_night).to eq 10.0
      expect(space.availability).to eq 'false'
      expect(space.user_id).to eq 1

    end

  end

  context 'UPDATE' do
    it 'changes the availability' do
      repo = SpaceRepository.new
      repo.book(1)
      space = repo.find_by_id(1)

      expect(space.availability).to eq 'false'
    end
  end


end 