require_relative 'space'
require_relative 'database_connection'

class SpaceRepository

  def all
    sql = 'SELECT id, name, description, price_per_night, available_from, available_to, user_id FROM spaces;'
    result = DatabaseConnection.exec_params(sql, [])
    spaces_array = []
    result.each do |row|
      spaces_array << get_space(row)
    end
    return spaces_array
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, description, price_per_night, available_from, available_to, user_id) VALUES($1, $2, $3, $4, $5, $6) RETURNING id;'

    params = [space.name, space.description, space.price_per_night, space.available_from, space.available_to, space.user_id]

    DatabaseConnection.exec_params(sql, params)
  end

  # remove this?
  def book(id)
    # sql = "UPDATE spaces SET availability = 'false' WHERE id = $1"
    # sql_params = [id]

    # DatabaseConnection.exec_params(sql, sql_params)
  end

  def find_by_id(id)
    sql = 'SELECT id, name, description, price_per_night, available_from, available_to, user_id
    FROM spaces WHERE id = $1'
    sql_params = [id]

    entry = DatabaseConnection.exec_params(sql,sql_params)[0]

    get_space(entry)
  end

  private

  def get_space(entry)
    space = Space.new
    space.id = entry['id'].to_i
    space.name = entry['name']
    space.description = entry['description']
    space.price_per_night = entry['price_per_night'].to_f
    space.available_from = entry['available_from']
    space.available_to = entry['available_to']
    space.user_id = entry['user_id'].to_i
    return space
  end
end