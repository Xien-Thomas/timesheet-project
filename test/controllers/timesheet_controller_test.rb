require "test_helper"

class TimesheetControllerTest < ActionDispatch::IntegrationTest
  # test "should get show" do
  #   get timesheet_show_url
  #   assert_response :success
  # end
  setup do
    @user1 = users(:user1)
    @user1_token = JWT.encode({ user_id: @user1.id }, Rails.application.secret_key_base, 'HS256')
    @entry1 = entries(:entry1)
    @user2 = users(:user2)
    @user2_token = JWT.encode({ user_id: @user2.id }, Rails.application.secret_key_base, 'HS256')
    @entry2 = entries(:entry2)
    @manager = users(:manager)
    @manager_token = JWT.encode({ user_id: @manager.id }, Rails.application.secret_key_base, 'HS256')
  end
  test "should respond with a timesheet with exactly 1 entry in it" do
    get '/timesheet/show', headers: { 'Authorization' => @user1_token }
    assert_equal JSON.parse(response.body).length, 1
  end
  test "should include entries with dates, hours and types" do
    get '/timesheet/show', headers: { 'Authorization' => @user1_token }
    assert !JSON.parse(response.body)[0]['date'].nil?
    assert !JSON.parse(response.body)[0]['hours'].nil?
    assert !JSON.parse(response.body)[0]['type'].nil?
  end
  test "should not have a body if the user is a manager or admin" do
    get '/timesheet/show', headers: { 'Authorization' => @manager_token }
    assert JSON.parse(response.body).nil?
  end
end
