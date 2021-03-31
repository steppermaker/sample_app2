require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user      = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 charecters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent firet" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "should reply" do
    destination = microposts(:ants)
    reply_micropost = microposts(:zone)
    assert_not destination.has_reply?(reply_micropost)
    destination.add_reply(reply_micropost)
    assert destination.has_reply?(reply_micropost)
    assert reply_micropost.reply_to == destination
  end

  test "associated reply should be deleted" do
    destination = microposts(:ants)
    reply_micropost = microposts(:zone)
    destination.add_reply(reply_micropost)
    assert_difference "Reply.count",-1 do
      destination.destroy
    end
  end
end
