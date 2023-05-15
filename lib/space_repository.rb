require_relative 'space'

class SpaceRepository

  def all
    sql = 'SELECT id, name, description, price_per_night, availability, user_id FROM spaces;'
    result = DatabaseConnection.exec_params(sql, [])
    spaces_array = []
    result.each do |row|
      space = Space.new
      space.id = row['id']
      space.name = row['name']
      space.description = row['description']
      space.price_per_night = row['price_per_night']
      space.availability = row['availability']
      space.user_id = row['user_id']
      spaces_array << space
    end
    return spaces_array
  end

  def create(space)
  end

  def book(space)
  end

end