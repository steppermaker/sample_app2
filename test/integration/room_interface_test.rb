require 'test_helper'

class RoomInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:mone)
    @mutual_follow_user = users(:mtwo)
  end

  test "room page" do
    log_in_as(@user)
    assert_difference 'Room.count' do
      post rooms_path, params: { user_id: @mutual_follow_user.id }
    end
    follow_redirect!
    assert_template 'rooms/show'
    assert_select 'ol#chat'
    assert_select 'div.posts'
    room = assigns(:room)
    assert_difference 'Message.count' do
      post messages_path, params: { message: { room_id: room.id, content: "test",
                                               addressee_user_id: @mutual_follow_user.id} }
    end
    assert_redirected_to room_url(room)
    follow_redirect!
    assert_select 'li.baloon_r'
    assert_select 'a.delete-message'
  end
end
