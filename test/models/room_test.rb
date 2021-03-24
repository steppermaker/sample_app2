require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @room = Room.new
  end

  test "should be valid" do
    assert @room.valid?
  end
end
