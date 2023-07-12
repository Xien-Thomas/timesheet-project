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
    @admin = users(:admin)
    @admin_token = JWT.encode({ user_id: @admin.id }, Rails.application.secret_key_base, 'HS256')
  end
  test "user#create should create an employee when you are an manager" do
    post "/user/create", 
      headers: { Authorization: @manager_token }, 
      params: { first_name: 'testing', last_name: 'testing', email: 'testing@example.com', 
        password: 'uhhhhhhhhhhh', vendor_name: 'Revature', role_name: 'Employee'}, 
      as: :json
    assert_response :created
    created_user = User.where(first_name: 'testing').first
    assert created_user[:first_name] == 'testing'
    assert created_user[:last_name] == 'testing'
    assert created_user[:email] == 'testing@example.com'
    assert created_user[:role_id] == Role.where(name: 'Employee').first[:id]
    assert created_user[:vendor_id] == Vendor.where(name: 'revature').first[:id]
    assert !created_user[:id].nil?
  end
  test "user#create should respond with unprocessable_entity if no data is given" do
    post "/user/create", 
      headers: { Authorization: @manager_token }
    assert_response :unprocessable_entity
  end
  test "user#create should respond with unprocessable_entity if bad data is given" do
    post "/user/create", 
    headers: { Authorization: @manager_token }, 
    params: { first_name: 'testing', last_name: 'testing', email: 'testing@example.com', 
      password: 'uhhhhhhhhhhh', vendor_name: 'A Vendor That Doesn\'t Exist', role_name: 'Employee'}, 
    as: :json
    assert_response :unprocessable_entity
  end
  test "user#create should not create a user when you are an employee" do
    post "/user/create", 
      headers: { Authorization: @user1_token }, 
      params: { first_name: 'testing', last_name: 'testing', email: 'testing@example.com', 
        password: 'uhhhhhhhhhhh', vendor_name: 'Revature', role_name: 'Employee'}, 
      as: :json
    assert_response :unauthorized
    created_user = User.where(first_name: 'testing').first
    assert created_user.nil?
  end
  test "user#create should not create a non-employee user when you are a manager" do
    post "/user/create", 
      headers: { Authorization: @manager_token }, 
      params: { first_name: 'testing', last_name: 'testing', email: 'testing@example.com', 
        password: 'uhhhhhhhhhhh', vendor_name: 'Revature', role_name: 'Literally Anything Else'}, 
      as: :json
    assert_response :unauthorized
    created_user = User.where(first_name: 'testing').first
    assert created_user.nil?
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
  test "user#destroy should delete an employee when you are an manager" do
    delete "/user/destroy/#{@user1.id}", 
      headers: { Authorization: @manager_token }
    assert_response :ok
    deleted_user = User.where(id: @user1.id).first
    assert deleted_user.nil?
  end
  
  test "user#destroy should respond with unprocessable_entity if bad id is given" do
    delete "/user/destroy/bad_id",
      headers: { Authorization: @manager_token }
    assert_response :unprocessable_entity
  end
  
  test "user#destroy should not destroy a user when you are an employee" do
    delete "/user/destroy/#{@user2.id}", 
      headers: { Authorization: @user2_token }
    assert_response :unauthorized
    destroyed_user = User.where(first_name: @user2.first_name).first
    assert destroyed_user
  end
  test "user#destroy should not delete a non-employee user when you are a manager" do
    delete "/user/destroy/#{@manager.id}", 
      headers: { Authorization: @manager_token } 
    assert_response :unauthorized
    destroyed_user = User.where(first_name: @manager.first_name).first
    assert destroyed_user
  end
  test "user#update should update an employee when you are an admin" do
    user1_id = @user1.id
    put "/user/update/#{user1_id}", 
      headers: { Authorization: @admin_token }, 
      params: { first_name: 'updated', last_name: 'updated', email: 'updated@example.com', 
        password: 'uhhhhhhhhhhh2', vendor_name: 'null', role_name: 'Manager', id: 0 }, 
      as: :json
    assert_response :ok
    updated_user = User.find_by_id(user1_id)
    assert updated_user[:first_name] == 'updated'
    assert updated_user[:last_name] == 'updated'
    assert updated_user[:email] == 'updated@example.com'
    assert updated_user[:vendor_id].nil?
    assert updated_user.is_a_manager?
    post '/login', params: { email: 'updated@example.com', password: 'uhhhhhhhhhhh2' }, as: :json
    assert_response :created
  end
  test "user#update should respond with ok but make no changes if no data is given" do
    put "/user/update/#{@user1.id}", 
      headers: { Authorization: @admin_token }
    assert_response :ok
  end
  test "user#update should respond with ok but make no changes if bad data is given" do
    put "/user/update/#{@user1.id}", 
    headers: { Authorization: @admin_token }, 
    params: { pizza: true }, 
    as: :json
    assert_response :ok
  end
  test "user#update should not update a user when you are a manager" do
    user1_id = @user1.id
    put "/user/update/#{@user1.id}", 
      headers: { Authorization: @manager_token }, 
      params: { first_name: 'updated', last_name: 'updated', email: 'updated@example.com', 
        password: 'uhhhhhhhhhhh2', vendor_name: nil, role_name: 'Manager', id: 0 }, 
      as: :json
    assert_response :unauthorized
    updated_user = User.find_by_id(user1_id)
    assert updated_user[:first_name] != 'updated'
    assert updated_user[:last_name] != 'updated'
    assert updated_user[:email] != 'updated@example.com'
    assert !updated_user[:vendor_id].nil?
    assert updated_user.is_not_a_manager?
    post '/login', params: { email: 'updated@example.com', password: 'uhhhhhhhhhhh2' }, as: :json
    assert_response :unauthorized
  end
  test "user#update should allow anyone to update their own password" do
    put "/user/update/#{@user2.id}", 
      headers: { Authorization: @user2_token }, 
      params: { first_name: 'updated', last_name: 'updated', email: 'updated@example.com', 
        password: 'uhhhhhhhhhhh2', vendor_name: nil, role_name: 'Manager', id: 0 }, 
      as: :json
    assert_response :ok
    updated_user = User.find_by_id(@user2.id)
    assert updated_user[:first_name] != 'updated'
    assert updated_user[:last_name] != 'updated'
    assert updated_user[:email] != 'updated@example.com'
    assert !updated_user[:vendor_id].nil?
    assert updated_user.is_not_a_manager?
    post '/login', params: { email: @user2.email, password: 'uhhhhhhhhhhh2' }, as: :json
    assert_response :created
    put "/user/update/#{@manager.id}", 
      headers: { Authorization: @manager_token }, 
      params: { first_name: 'updated', last_name: 'updated', email: 'updated@example.com', 
        password: 'uhhhhhhhhhhh2', vendor_name: nil, role_name: 'Admin', id: 0 }, 
      as: :json
    assert_response :ok
    updated_user = User.find_by_id(@manager.id)
    assert updated_user[:first_name] != 'updated'
    assert updated_user[:last_name] != 'updated'
    assert updated_user[:email] != 'updated@example.com'
    assert updated_user[:vendor_id].nil?
    assert updated_user.is_not_an_admin?
    post '/login', params: { email: @manager.email, password: 'uhhhhhhhhhhh2' }, as: :json
    assert_response :created
    put "/user/update/#{@admin.id}", 
      headers: { Authorization: @admin_token }, 
      params: { password: 'uhhhhhhhhhhh2' }, 
      as: :json
    assert_response :ok
    post '/login', params: { email: @admin.email, password: 'uhhhhhhhhhhh2' }, as: :json
    assert_response :created
  end
end
  