require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:ants)
    @user      = users(:michael)
    @like      = likes(:one)
  end

  test "should redirect like when not logged in" do
    post likes_path, params: { micropost_id: @micropost.id }
    assert_redirected_to login_url
  end

  test "should redirect unlike when not logged in" do
    delete like_path(@like)
    assert_redirected_to login_url
  end
end
