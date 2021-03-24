require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @room = rooms(:first_room)
    @new_room = Room.new
    @user = users(:michael)
    @non_mutual_user = users(:mone)
  end
  test "should redirect show when not loggin" do
    get room_path(@room)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not loggin" do
    post rooms_path(@new_room), params: { user_id: @user.id }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not with mutual user" do
    log_in_as(@user)
    post rooms_path(@new_room), params: { user_id: @non_mutual_user.id }
    assert_redirected_to root_url
  end
end
