require "test_helper"
require_relative "../../lib/json_web_token.rb"

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = users(:manager)
    @manager_token = JWT.encode({ user_id: @manager.id }, Rails.application.secret_key_base, 'HS256')
  end
  test "user#index should return json containing the users of the specified vendor" do
    get '/user/index/revature', headers: { 'Authorization' => @manager_token}
    assert_equal JSON.parse(response.body).size, 1
    assert !JSON.parse(response.body)[0]['first_name'].nil?
    assert !JSON.parse(response.body)[0]['last_name'].nil?
    assert !JSON.parse(response.body)[0]['id'].nil?
    assert JSON.parse(response.body)[0]['password_digest'].nil?
    assert JSON.parse(response.body)[0]['email'].nil?
  end
  test "user#index should return json containing the users of all vendors with no arguments" do
    get '/user/index', headers: { 'Authorization' => @manager_token}
    assert_equal JSON.parse(response.body).size, 2
  end
end
