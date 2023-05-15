require_relative 'space'

class SpaceRepository

  def all
    sql = 'SELECT id, name, description, price_per_night, availability, user_id FROM spaces;'
    result = DatabaseConnection.exec_params(sql, [])
    spaces_array = []
    result.each do |row|
      space = Space.new
      space.id, space.name, space.description, space.price_per_night, space.availability, space.user_id = 
        row['id'], row['name'], row['description'], row['price_per_night'], row['availability'], row['user_id']
      spaces_array << space
    end
    return spaces_array
  end

  def create(space)
  end

  def book(space)
  end

end