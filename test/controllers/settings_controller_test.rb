require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test "should get new" do
    log_in_as(@user)
    get settings_new_url
    assert_response :success
  end

  test "should rediect change name when not logged in" do
    get change_name_settings_path(@user)
    assert_redirected_to login_url
  end

  test "should rediect change email when not logged in" do
    get change_email_settings_path(@user)
    assert_redirected_to login_url
  end

  test "should rediect change password when not logged in" do
    get change_password_settings_path(@user)
    assert_redirected_to login_url
  end

  test "should rediect change profile when not logged in" do
    get change_profile_settings_path(@user)
    assert_redirected_to login_url
  end


end
