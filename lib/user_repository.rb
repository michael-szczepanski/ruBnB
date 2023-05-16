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

  def log_in(email, password)
    query = 'SELECT id, name, username, email, password FROM users WHERE email = $1;'
    params = [email]
    entry = DatabaseConnection.exec_params(query, params).first
    return nil if entry.empty?
    stored_password = BCrypt::Password.new(entry["password"])
    return nil unless stored_password == password
    user = User.new
    user.id, user.name =
      entry["id"].to_i, entry["name"]
    return user
  end
end