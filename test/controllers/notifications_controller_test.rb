require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get notifications_new_url
    assert_redirected_to root_path
  end

end
