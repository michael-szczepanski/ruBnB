require_relative 'booking'
require_relative 'database_connection'

class BookingRepository
  def find_by_user(user_id)
    query = "SELECT id, date, request_status, user_id, space_id FROM bookings WHERE user_id = $1;"
    params = [user_id]
    entries = DatabaseConnection.exec_params(query, params)
    return extract_bookings(entries)
  end

  def find_for_user(user_id)
    query = 'SELECT bookings.id, bookings.date, bookings.request_status, bookings.user_id, bookings.space_id 
              FROM bookings WHERE bookings.space_id 
              IN (SELECT spaces.id FROM spaces WHERE spaces.user_id = $1);'
    params = [user_id]
    result = DatabaseConnection.exec_params(query, params)
    return extract_bookings(result)
  end

  def create(date, user_id, space_id)
    query = 'INSERT INTO bookings (date, user_id, space_id) VALUES ($1, $2, $3);'
    params = [date, user_id, space_id]

    DatabaseConnection.exec_params(query, params)
    return nil
  end

  def confirm(booking_id)
    query = "UPDATE bookings SET request_status = 'confirmed' WHERE id = $1;"
    params = [booking_id]
    DatabaseConnection.exec_params(query, params)
  end

  def deny(booking_id)
    query = "UPDATE bookings SET request_status = 'denied' WHERE id = $1;"
    params = [booking_id]
    DatabaseConnection.exec_params(query, params)
  end

  private

  def extract_bookings(entries)
    bookings = []
    for entry in entries do
      booking = Booking.new
      booking.id = entry['id'].to_i
      booking.date = Date.parse(entry['date'])
      booking.request_status = entry['request_status']
      booking.user_id = entry['user_id'].to_i
      booking.space_id = entry['space_id'].to_i
      bookings << booking
    end
    return bookings
  end
end