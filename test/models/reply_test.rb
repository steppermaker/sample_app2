require 'test_helper'

class ReplyTest < ActiveSupport::TestCase

  def setup
    @reply = Reply.new(destination_id: microposts(:ants).id,
                       reply_micropost_id: microposts(:zone).id)
  end

  test "should be valid" do
    assert @reply.valid?
  end

  test "should require a destination_id" do
    @reply.destination_id = nil
    assert_not @reply.valid?
  end

  test "should require a reply_micropost_id" do
    @reply.reply_micropost_id = nil
    assert_not @reply.valid?
  end
end
