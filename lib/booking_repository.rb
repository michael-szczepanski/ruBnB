require_relative 'booking'
require_relative 'database_connection'

class BookingRepository
  def find_by_user_id(user_id)
    query = "SELECT id, date, request_status, user_id, space_id FROM bookings WHERE user_id = $1;"
    params = [user_id]
    entries = DatabaseConnection.exec_params(query, params)
    return extract_bookings(entries)
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