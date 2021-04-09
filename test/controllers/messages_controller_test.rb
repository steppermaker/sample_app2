require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @message = messages(:first_message);
    @user = users(:michael)
    @other_user = users(:lana)
    @room = rooms(:first_room)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { room_id: @room.id, content: "test",
                                               addressee_user_id: @other_user.id} }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Message.count' do
      delete message_path(@message)
    end
    assert_redirected_to login_url
  end

  test "should redirect create for wrong room" do
    log_in_as(@user)
    room = rooms(:second_room)
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { room_id: room.id, content: "test",
                                               addressee_user_id: @other_user.id} }
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy for wrong message" do
    log_in_as(@other_user)
    assert_no_difference 'Message.count' do
      delete message_path(@message)
    end
    assert_redirected_to root_path
  end
end
