require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user1 = users(:user1)
        @user1_token = JsonWebToken.encode('user_id' => @user1.id)
        @user1_auth = {"Authorization" => "Bearer #{@user1_token}"}

        @manager1 =users(:manager)
        @manager1_token = JsonWebToken.encode('user_id' => @manager1.id)
        @manager1_auth = {'Authorization' => "Bearer #{@manager1_token}"}


    end

    test 'should be true' do
        assert true
    end

    test 'Manager should be able to get contractors' do
        get '/users', headers: @manager1_auth, params: {vendor: 'Revature'}

        assert_not_empty response.body
        assert_response :ok
    end

    test 'Employee should not be able to get contractors' do
        get '/users', headers: @user1_auth, params: {vendor: 'Revature'}

        assert_response :unauthorized
    end
end
