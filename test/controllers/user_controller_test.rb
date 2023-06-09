require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user1 = users(:user1)
        @user1_token = JsonWebToken.encode('user_id' => @user1.id)
        @user1_Auth = {"Autherization" => "Bearer #{@user1_token}"}

        @manager1 =users(:manager)
        @manager1_token = JsonWebToken.encode('user_id' => @manager1.id)
    end

    test 'should be true' do
        assert true
    end

    test 'Manager should be able to get contractors' do
        
    end
end
