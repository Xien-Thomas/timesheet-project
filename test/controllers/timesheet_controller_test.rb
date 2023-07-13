require "test_helper"
require_relative '../set_up_test.rb'

class TimesheetControllerTest < ActionDispatch::IntegrationTest
  extend SetUpTest
  set_up_test
  
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
