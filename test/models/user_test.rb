require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Exsample User", email: "user@exsample.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be vaild" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a" * 244 + "@exsample.com"
    assert_not @user.valid?
  end

  test "email addresses validation should valid addresses" do
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimun length" do
    @user.password = @password_confirmation = "a" * 6
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    user1 = users(:michael)
    user2 = users(:archer)
    assert_not user1.following?(user2)
    user1.follow(user2)
    assert user1.following?(user2)
    assert user2.followers.include?(user1)
    user1.unfollow(user2)
    assert_not user1.following?(user2)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    archer.microposts.each do |post_unfollowing|
      assert_not michael.feed.include?(post_unfollowing)
    end
  end
end
