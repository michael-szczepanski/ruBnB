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

  context '#log_in' do
    it 'should return a user object given correct credentials' do
      repo = UserRepository.new
      user = repo.log_in('jack@email.com', 'pwtest1')

      expect(user.name).to eq 'Jack'
      expect(user.id).to eq 1
    end
  end

  context 'READ' do
    it 'rejects duplicate usernames' do
      repo = UserRepository.new
      expect(repo.is_username_unique?('skates')).to eq false
      expect(repo.is_username_unique?('sup')).to eq true
    end

    it 'rejects duplicate emails' do
      repo = UserRepository.new
      expect(repo.is_email_unique?('jack@email.com')).to eq false
      expect(repo.is_email_unique?('sup')).to eq true
    end
  end
end