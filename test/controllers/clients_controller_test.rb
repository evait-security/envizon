require 'test_helper'

class ClientControllerTest < ActionDispatch::IntegrationTest
 # test 'should get clients' do
    # # get clients_url, params: { id: clients(:one).id }
    # get '/clients'
    # assert_response :success
  # end

  test 'should get client' do
    # get clients_url, params: { id: clients(:one).id }
    get "/clients/#{clients(:one).id}"
    assert_redirected_to root_path
  end

  test 'global_search should fail silently if no :search' do
    post global_search_path
    assert_redirected_to root_path
  end
end
