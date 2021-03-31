require 'test_helper'

class LikeMicropostsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    log_in_as(@user)
  end

  test "likes page" do
    get likes_micropost_path(@micropost)
    assert_select ".users > li", count: 0
    assert_difference "Like.count" do
      post likes_path, params: { micropost_id: @micropost.id }
    end
    get likes_micropost_path(@micropost)
    assert_select ".users > li"
    @like = @micropost.likes.find_by(user_id: @user.id)
    assert_difference "Like.count",-1 do
      delete like_path(@like)
    end
    get likes_micropost_path(@micropost)
    assert_select ".users > li", count: 0
  end

  test "like micropost" do
    get root_path
    assert_select "span.content", text: @micropost.content
    assert_not @micropost.like?(@user)
    assert_difference "Like.count" do
      post likes_path, params: { micropost_id: @micropost.id }
    end
    assert @micropost.like?(@user)
    assert_redirected_to root_path
    follow_redirect!
    @like = @micropost.likes.find_by(user_id: @user.id)
    assert_difference "Like.count",-1 do
      delete like_path(@like)
    end
    assert_not @micropost.like?(@user)
    assert_redirected_to root_path
  end

  test "like a micropost with Ajax" do
    assert_difference "Like.count" do
      post likes_path, xhr: true, params: { micropost_id: @micropost.id }
    end
  end

  test "unlike a micropost with Ajax" do
    post likes_path, xhr: true, params: { micropost_id: @micropost.id }
    @like = @micropost.likes.find_by(user_id: @user.id)
    assert_difference "Like.count", -1 do
      delete like_path(@like), xhr:true
    end
  end
end
