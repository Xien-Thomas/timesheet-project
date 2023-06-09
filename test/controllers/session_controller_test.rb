require "test_helper"
require_relative '../../lib/json_web_token.rb'

class SessionControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)
  end
  test "should login" do
    post session_create_url, params: { email: @user1.email, password: 'password1' }, as: :json
    assert_response :created
    assert_equal JSON.parse(response.body)['first_name'], @user1.first_name
    assert_equal JSON.parse(response.body)['last_name'], @user1.last_name
    assert JsonWebToken.decode(JSON.parse(response.body)['token'])['user_id'] == @user1.id
  end

  test "should not login" do
    post session_create_url, params: { email: @user1.email, password: '2' }, as: :json
    assert_response :unauthorized
  end

end
