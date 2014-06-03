require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "simple meeting" do
    meet = Meeting.new
    meet.day = 2
    meet.year= 2001
    meet.month = 1
    meet.notes = "first test meeting"
    meet.room_id = 1
    meet.start_at = DateTime.new(2001,1,2,3,4)
    meet.end_at = DateTime.new(2001,1,2,3,4)
    assert meet.save
  end
end
