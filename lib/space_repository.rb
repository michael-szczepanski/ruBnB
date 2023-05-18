require_relative 'space'
require_relative 'booking'
require_relative 'database_connection'
require 'time'
# require 'date'
# require 'datetime'


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

  def all_by_user(id)
    sql = 'SELECT id, name, description, price_per_night, available_from, available_to, user_id FROM spaces WHERE user_id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
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
    date_range = date_availabilty_range(entry['available_from'], entry['available_to'])
    result = get_space(entry)
    result.availabilty_range = date_range
    return result
  end

  def find_top_spaces
    sql = "SELECT spaces.id, spaces.name, spaces.description, spaces.price_per_night FROM spaces WHERE spaces.id IN (
      SELECT bookings.space_id
      FROM bookings
      GROUP BY bookings.space_id
      ORDER BY COUNT(bookings.space_id) DESC
      LIMIT 2
    );"
    sql_params = []
    result = DatabaseConnection.exec_params(sql, sql_params)
    spaces_array = []

    result.each do |entry|
      spaces_array << get_space(entry)
    end
    return spaces_array
  end

  def availability_status(id)
    space = find_by_id(id).availabilty_range
    bookings = get_confirmed_bookings(id)

    space.map do |date|
      if bookings.include? date
        date = { date: date, status: "unavailable"}
      else
        date = { date: date, status: "available"}
      end
    end
  end
  
  private

  def date_availabilty_range(available_from, available_to)
    new_from = Date.parse(available_from)
    new_to = Date.parse(available_to)
    range = (new_from..new_to).map do |date|
      date.strftime('%Y-%m-%d')
    end
    return range
  end

  def get_confirmed_bookings(id)
    sql = "SELECT date FROM bookings WHERE space_id = $1 AND request_status = 'confirmed'"

    params = [id]

    result = DatabaseConnection.exec_params(sql, params)

    bookings = []
    result.each do |booking|
      confirmed_booking = Booking.new
      confirmed_booking.date = booking['date']
      bookings << confirmed_booking.date
    end

    return bookings
  end

  def get_space(entry)
    space = Space.new
    space.id = entry['id'].to_i
    space.name = entry['name']
    space.description = entry['description']
    space.price_per_night = sprintf("%.2f", entry['price_per_night'])
    space.available_from = entry['available_from']
    space.available_to = entry['available_to']
    space.user_id = entry['user_id'].to_i
    return space
  end
end