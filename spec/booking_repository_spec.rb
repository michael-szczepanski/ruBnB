require 'booking_repository'

RSpec.describe BookingRepository do
  before(:each) do
    reset_tables
  end

  context 'READ' do
    it '# find_by_user gets relevant bookings out' do
      repo = BookingRepository.new
      entries = repo.find_by_user(1).to_a
      expect(entries.length).to eq 1
      expect(entries.first.id).to eq 4
      expect(entries.first.date.to_s).to eq "2023-05-19"
      expect(entries.first.request_status).to eq "denied"
      expect(entries.first.user_id).to eq 1
      expect(entries.first.space_id).to eq 3
    end

    it '# find_for_user gets relevant bookings out' do
      repo = BookingRepository.new
      entries = repo.find_for_user(1).to_a
      expect(entries.length).to eq 3
      expect(entries.first.id).to eq 1
      expect(entries.first.date.to_s).to eq "2023-05-20"
      expect(entries.first.request_status).to eq "pending"
      expect(entries.first.user_id).to eq 2
      expect(entries.first.space_id).to eq 1
      expect(entries.last.id).to eq 3
      expect(entries.last.date.to_s).to eq "2023-05-26"
      expect(entries.last.request_status).to eq "pending"
      expect(entries.last.user_id).to eq 3
      expect(entries.last.space_id).to eq 2
    end

    it 'finds by booking ID' do
      repo = BookingRepository.new
      booking = repo.find_by_id(1)
      expect(booking.date.to_s).to eq '2023-05-20'
      expect(booking.request_status).to eq "pending"
      expect(booking.user_id).to eq 2
      expect(booking.space_id).to eq 1
    end
  end
  context '#create booking' do
    it 'should create a new booking associated with a user and space id' do
      repo = BookingRepository.new
      request = repo.create('2023-05-16', 3, 1)
      booking = repo.find_by_user(3).last

      expect(booking.id).to eq 7
      expect(booking.date.to_s).to eq '2023-05-16'
      expect(booking.request_status).to eq "pending"
      expect(booking.user_id).to eq 3
      expect(booking.space_id).to eq 1
    end
  end
  context "UPDATE" do
    it '#confirm sets request_status to confirmed' do
      repo = BookingRepository.new
      repo.confirm(1)
      entries = repo.find_for_user(1)
      expect(entries.last.request_status).to eq "confirmed"
    end

    it '#deny sets request_status to denied' do
      repo = BookingRepository.new
      repo.deny(1)
      entries = repo.find_for_user(1)
      expect(entries.last.request_status).to eq "denied"
    end

    it 'auto-denies a booking that clash on dates' do
      repo = BookingRepository.new
      repo.confirm(2)
      
      confirmed_booking = repo.find_by_id(2)
      expect(confirmed_booking.request_status).to eq "confirmed"
    
      denied_booking = repo.find_by_id(3)
      expect(denied_booking.request_status).to eq "denied"
    
    end

    it 'auto-denies multiple bookings that clash on dates' do
      repo = BookingRepository.new
      repo.create('2023-05-26',3,2)
      
      repo.confirm(2)

      repo = BookingRepository.new

      
      confirmed_booking = repo.find_by_id(2)
      expect(confirmed_booking.request_status).to eq "confirmed"
    
      denied_booking = repo.find_by_id(3)
      expect(denied_booking.request_status).to eq "denied"

      denied_booking = repo.find_by_id(7)
      expect(denied_booking.request_status).to eq "denied"
    
    end
  end
end

