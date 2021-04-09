require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @non_following_user = users(:archer)
    @mutual_follow_user = users(:lana)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'div.show_user_name', text: @user.name
    assert_select 'img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'ul.pagination'
    @user.microposts.page(1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'div#follow_form', count: 0
    assert_select 'div#room_button', count: 0
    assert_select 'div.stats>a', text: 'unread', count: 0
  end

  test "profile display when logged in" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div#follow_form', count: 0
    assert_select 'div#room_button', count: 0
  end

  test "mutual_follow_user profile display when logged in" do
    log_in_as(@user)
    get user_path(@mutual_follow_user)
    assert_template 'users/show'
    assert_select 'div#follow_form'
    assert_select 'div#room_button'
    assert_select 'div.stats>a', text: 'unread', count: 0
  end
end
