require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user         = users(:michael)
    @other_user   = users(:archer)
    @non_actived = users(:non_actived)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
    assert_not flash.empty?
    log_in_as(@user)
    follow_redirect!
    assert_template 'users/index'
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { current_password: "password",
                                                    password: "password",
                                                    admin: true },
                                            change: "password" }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not loggin" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect show when non-actived user's page" do
    log_in_as(@user)
    get user_path(@non_actived)
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
