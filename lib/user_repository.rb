require 'bcrypt'
require_relative 'database_connection'
require_relative 'user'

class UserRepository
  def create(user)
    query = "INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4) RETURNING id, name, username, email, password;"

    encrypted_password = BCrypt::Password.create(user.password)

    params = [user.name, user.username, user.email, encrypted_password]
    DatabaseConnection.exec_params(query, params)
  end
end