require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @message = Message.new(user_id: users(:michael).id,
                           room_id: rooms(:second_room).id,
                           content: "Test",
                           addressee_user_id: users(:lana).id,
                           read: false)
  end

  test "should be valid" do
    assert @message.valid?
  end

  test "should require a user_id" do
    @message.user_id = nil
    assert_not @message.valid?
  end

  test "should require a room_id" do
    @message.room_id = nil
    assert_not @message.valid?
  end

  test "should require a content_id" do
    @message.content = nil
    assert_not @message.valid?
  end

  test "should require a addressee_user_id" do
    @message.addressee_user_id = nil
    assert_not @message.valid?
  end

  test "content should be present" do
    @message.content = " "
    assert_not @message.valid?
  end

  test "content should be at most 140 charecters" do
    @message.content = "a" * 141
    assert_not @message.valid?
  end
end
