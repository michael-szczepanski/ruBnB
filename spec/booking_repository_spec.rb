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
  end
end

