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

end
