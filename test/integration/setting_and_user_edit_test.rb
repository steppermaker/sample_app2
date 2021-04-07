require 'test_helper'

class SettingAndUserEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "setting and user edit" do
    get new_setting_path
    assert_redirected_to login_path

    get change_name_settings_path
    assert_redirected_to login_path

    get change_email_settings_path
    assert_redirected_to login_path

    get change_password_settings_path
    assert_redirected_to login_path

    log_in_as(@user)
    get new_setting_path
    assert_template "settings/new"
    assert_select "ol.setting"
    assert_select "a[href=?]", change_name_settings_path, text: "Change name"
    assert_select "a[href=?]", change_email_settings_path, text: "Change email"
    assert_select "a[href=?]", change_password_settings_path, text: "Change password"
  end

  test "update user name" do
    log_in_as(@user)
    get change_name_settings_path
    assert_template "settings/change_name"
    patch user_path(@user), params: { user: { name: "", password: "password" },
                                      change: "name" }
    assert_template "settings/change_name"

    patch user_path(@user), params: { user: { name: "Sample", password: "" },
                                      change: "name" }
    assert_template "settings/change_name"
    assert_not flash.empty?

    patch user_path(@user), params: { user: { name: "Sample", password: "password" },
                                      change: "name" }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select "h1", text: "Sample"
  end

  test "update user email" do
    log_in_as(@user)
    get change_email_settings_path
    assert_template "settings/change_email"
    patch user_path(@user), params: { user: { email: "", password: "password" },
                                    change: "email" }
    assert_template "settings/change_email"

    patch user_path(@user), params: { user: { email: "a@a.com", password: "" },
                                    change: "email" }
    assert_template "settings/change_email"
    assert_not flash.empty?

    patch user_path(@user), params: { user: { email: "a@a.com", password: "wrong" },
                                    change: "email" }
    assert_template "settings/change_email"
    assert_not flash.empty?

    patch user_path(@user), params: { user: { email: "a@a.com", password: "password" },
                                    change: "email" }
    assert_redirected_to user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    post login_path params: { session: { email: "a@a.com", password: "password" } }
    assert is_logged_in?
  end

  test "update user password" do
    log_in_as(@user)
    get change_password_settings_path
    assert_template "settings/change_password"
    patch user_path(@user), params: { user: { current_password: "",
                                            password: "new_password",
                                            password_confirmation: "new_passsword"},
                                    change: "password" }
    assert_template "settings/change_password"
    assert_not flash.empty?

    patch user_path(@user), params: { user: { current_password: "password",
                                            password: "",
                                            password_confirmation: "new_passsword"},
                                    change: "password" }
    assert_template "settings/change_password"

    patch user_path(@user), params: { user: { current_password: "password",
                                            password: "new_password",
                                            password_confirmation: ""},
                                    change: "password" }
    assert_template "settings/change_password"

    patch user_path(@user), params: { user: { current_password: "password",
                                            password: "",
                                            password_confirmation: ""},
                                    change: "password" }
    assert_template "settings/change_password"

    patch user_path(@user), params: { user: { current_password: "password",
                                            password: "new_password",
                                            password_confirmation: "new_password"},
                                    change: "password" }
    assert_redirected_to user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    post login_path params: { session: { email: @user.email, password: "new_password" } }
    assert is_logged_in?
  end
end
