require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

  test "should redirect create for wrong destination" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_difference "Reply.count" do
      post microposts_path, params: { micropost: { content: "Lorem" },
                                    destination_id: micropost.id}
    end
    reply = Micropost.first
    assert micropost.has_reply?(reply)
    assert_redirected_to micropost_path(micropost)
  end
end
