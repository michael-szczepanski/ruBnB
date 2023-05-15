require_relative 'space'
require_relative 'database_connection'

class SpaceRepository

  def all
  end

  def create(space)
  end

  def book(id)
    sql = "UPDATE spaces SET availability = 'false' WHERE id = $1"
    sql_params = [id]

    DatabaseConnection.exec_params(sql,sql_params)

  end

  def find_by_id(id)
    sql = 'SELECT id, name, description, price_per_night, availability, user_id
    FROM spaces WHERE id = $1'
    sql_params = [id]

    entry = DatabaseConnection.exec_params(sql,sql_params)[0]

    space = Space.new
    space.id = entry['id'].to_i
    space.name = entry['name']
    space.description = entry['description']
    space.price_per_night = entry['price_per_night'].to_f
    space.availability = entry['availability']
    space.user_id = entry['user_id'].to_i

    return space

  end
end