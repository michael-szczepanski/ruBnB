require 'user_repository'

RSpec.describe UserRepository do
  before(:each) do
    reset_tables
  end

  context 'CREATE' do
    it 'adds a new user to database' do
      repo = UserRepository.new
      user = double name: "Mike", username: "mike", email: "mike@mike.com", password: "$2a$12$RWbFtjHnA3kC2Gt31m7/l.N4f8ISipDp9T7KIyvSHhww/sGqohGHS"
      response = repo.create(user)
      entry = response.first
      expect(entry['id'].to_i).to eq 3
      expect(entry['name']).to eq user.name
      expect(entry['email']).to eq user.email
    end
  end
end