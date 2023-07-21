module SetUpTest
    def set_up_test
        setup do
            @user1 = users(:user1)
            @user1_token = JWT.encode({ user_id: @user1.id }, Rails.application.secret_key_base, 'HS256')
            @user2 = users(:user2)
            @user2_token = JWT.encode({ user_id: @user2.id }, Rails.application.secret_key_base, 'HS256')
            @manager = users(:manager)
            @manager_token = JWT.encode({ user_id: @manager.id }, Rails.application.secret_key_base, 'HS256')
            @admin = users(:admin)
            @admin_token = JWT.encode({ user_id: @admin.id }, Rails.application.secret_key_base, 'HS256')
            @entry1 = entries(:entry1)
            @entry2 = entries(:entry2)
            @entry3 = entries(:entry3)
            @vendor1 = vendors(:vendor1)
            @vendor2 = vendors(:vendor2)
        end

    end

end 