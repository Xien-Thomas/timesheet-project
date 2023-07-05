require "test_helper"
require_relative "../../lib/json_web_token.rb"

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:user1)
    @user1_token = JWT.encode({ user_id: @user1.id }, Rails.application.secret_key_base, 'HS256')
    @user2 = users(:user2)
    @user2_token = JWT.encode({ user_id: @user2.id }, Rails.application.secret_key_base, 'HS256')
    @manager = users(:manager)
    @manager_token = JWT.encode({ user_id: @manager.id }, Rails.application.secret_key_base, 'HS256')
  end
  test "user#show should show employee when that employee is you" do
    get "/user/#{@user1.id}", headers: { Authorization: @user1_token } 
    assert_response :ok
    assert !JSON.parse(response.body)['first_name'].nil?
    assert !JSON.parse(response.body)['last_name'].nil?
    assert !JSON.parse(response.body)['email'].nil?
    assert !JSON.parse(response.body)['id'].nil?
    assert !JSON.parse(response.body)['vendor_name'].nil?
    assert !JSON.parse(response.body)['role_name'].nil?
  end
  test "user#show should show employee when you are a manager" do
    get "/user/#{@user1.id}", headers: { Authorization: @manager_token } 
    assert_response :ok
    assert !JSON.parse(response.body)['first_name'].nil?
    assert !JSON.parse(response.body)['last_name'].nil?
    assert !JSON.parse(response.body)['email'].nil?
    assert !JSON.parse(response.body)['id'].nil?
    assert !JSON.parse(response.body)['vendor_name'].nil?
    assert !JSON.parse(response.body)['role_name'].nil?
  end
  test "user#show should show manager when you are a manager" do
    get "/user/#{@manager.id}", headers: { Authorization: @manager_token } 
    assert_response :ok
    assert !JSON.parse(response.body)['first_name'].nil?
    assert !JSON.parse(response.body)['last_name'].nil?
    assert !JSON.parse(response.body)['email'].nil?
    assert !JSON.parse(response.body)['id'].nil?
    assert !JSON.parse(response.body)['role_name'].nil?
    assert JSON.parse(response.body)['vendor_name'].nil?
  end
  test "user#show should not show employee when that employee is not you and you are an employee" do
    get "/user/#{@user1.id}", headers: { Authorization: @user2_token } 
    assert_response :unauthorized
    assert JSON.parse(response.body).nil?
  end
  test "user#show should respond with unprocessable entity if the user is not found" do
    get "/user/frog", headers: { Authorization: @manager_token } 
    assert_response :unprocessable_entity
    assert JSON.parse(response.body).nil?
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
