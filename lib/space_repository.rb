require 'space'

class SpaceRepository

  def all
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, description, price_per_night, availability, user_id) VALUES($1, $2, $3, $4, $5) RETURNING id;'

    params = [space.name, space.description, space.price_per_night, space.availability, space.user_id]

    DatabaseConnection.exec_params(sql, params)
  end

  def book(space)
  end

end