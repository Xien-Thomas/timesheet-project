require "test_helper"

class UserTest < ActiveSupport::TestCase
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
  test "is_an_employee? works" do
    assert @user1.is_an_employee?
    assert @manager.is_an_employee? == false
    assert @admin.is_an_employee? == false
  end
  test "is_a_manager? works" do
    assert @user1.is_a_manager? == false
    assert @manager.is_a_manager?
    assert @admin.is_a_manager? == false
  end
  test "is_an_admin? works" do
    assert @user1.is_an_admin? == false
    assert @manager.is_an_admin? == false
    assert @admin.is_an_admin?
  end
  test "is_not_an_employee? works" do
    assert @user1.is_not_an_employee? == false
    assert @manager.is_not_an_employee?
    assert @admin.is_not_an_employee?
  end
  test "is_not_a_manager? works" do
    assert @user1.is_not_a_manager?
    assert @manager.is_not_a_manager? == false
    assert @admin.is_not_a_manager?
  end
  test "is_not_an_admin? works" do
    assert @user1.is_not_an_admin?
    assert @manager.is_not_an_admin?
    assert @admin.is_not_an_admin? == false
  end
end
