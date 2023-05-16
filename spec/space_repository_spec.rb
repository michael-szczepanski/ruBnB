require 'space_repository'
require 'space'

RSpec.describe SpaceRepository do

  before(:each) do
    reset_tables
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
