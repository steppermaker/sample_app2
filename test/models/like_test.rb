require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @micropost = microposts(:ants)
    @like = @micropost.likes.build(user_id: users(:michael).id)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should require a micropost_id" do
    @like.micropost_id = nil
    assert_not @like.valid?
  end

  test "should require a user_id" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  test "should like and unlike a micropost" do
    micropost = microposts(:ants)
    user      = users(:michael)
    assert_not micropost.like?(user)
    micropost.like(user)
    assert micropost.like?(user)
    micropost.unlike(user)
    assert_not micropost.like?(user)
  end
end
