require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers
  test 'should get groups' do
    # sign_in users(:john)
    get pages_groups_url
    # puts @response.body
    assert_response :success
  end
end
