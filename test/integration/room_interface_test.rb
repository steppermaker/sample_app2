require 'test_helper'

class RoomInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:mone)
    @mutual_follow_user = users(:mtwo)
  end

  test "room page" do
    assert_no_difference 'Room.count' do
      post rooms_path, params: { user_id: @mutual_follow_user.id }
    end
    assert_redirected_to login_url

    log_in_as(@user)

    assert_no_difference 'Room.count' do
      post rooms_path, params: { user_id: @user.id }
    end
    assert_redirected_to root_url

    assert_difference 'Room.count' do
      post rooms_path, params: { user_id: @mutual_follow_user.id }
    end
    follow_redirect!
    assert_template 'rooms/show'
    assert_select 'ol#chat'
    assert_select 'div.posts'
    room = assigns(:room)

    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { room_id: room.id, content: " ",
                                               addressee_user_id: @mutual_follow_user.id} }
    end


    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { room_id: room.id, content: "test",
                                               addressee_user_id: @user.id} }
    end


    assert_difference 'Message.count' do
      post messages_path, params: { message: { room_id: room.id, content: "test",
                                               addressee_user_id: @mutual_follow_user.id} }
    end
    assert_redirected_to room_url(room)
    follow_redirect!
    assert_select 'li.baloon_r'
    assert_select 'a.delete-message'

    message = Message.last
    assert_difference 'Message.count',-1 do
      delete message_path(message)
    end
  end
end
