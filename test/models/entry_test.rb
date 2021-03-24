require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def setup
    @entry = Entry.new(user_id: users(:michael).id,
                       room_id: rooms(:first_room).id)
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "should require a user_id" do
    @entry.user_id = nil
    assert_not @entry.valid?
  end

  test "should require a room_id" do
    @entry.room_id = nil
    assert_not @entry.valid?
  end
end
