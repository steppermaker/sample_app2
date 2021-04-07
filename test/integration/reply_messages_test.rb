require 'test_helper'

class ReplyMessagesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @micropost = microposts(:ants)
  end

  test "should reply to a micropost" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "test" },
                                      destination_id: @micropost.id}
    end
    assert_redirected_to login_path

    log_in_as(@user)
    assert_difference 'Reply.count' do
      post microposts_path, params: { micropost: { content: "test" },
                                      destination_id: @micropost.id}
    end
    assert @micropost.has_reply?(Micropost.first)
    reply_micropost = assigns(:micropost)
    assert_redirected_to micropost_path(@micropost)
    follow_redirect!
    assert_select "div.content", text: "test"
    assert_difference 'Reply.count', -1 do
      delete micropost_path(reply_micropost)
    end
  end

  test "a micropost page display" do
    get micropost_path(@micropost)
    assert_template "microposts/show"
    assert_select "span.user", text: @micropost.user.name
    assert_select "span.show_content", text: @micropost.content
    assert_select "span.timestamp"
    assert_select ".counts"
    assert_select "span.like"
    assert_select "span.reply"
  end
end
