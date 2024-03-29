require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def  setup
    @admin        = users(:michael)
    @non_admin    = users(:archer)
    @non_actived  = users(:non_actived)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    assert_select 'div.search-user'
    first_page_of_users = User.page(1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    non_admin = @non_admin
    assert_select "a[href=?]", user_path(non_admin.id),
                               text: non_admin.name, count: 0
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select "a", text: "delete", count: 0
  end
end
