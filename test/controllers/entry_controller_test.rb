require "test_helper"
require_relative '../set_up_test.rb'

class EntryControllerTest < ActionDispatch::IntegrationTest
  extend SetUpTest
  set_up_test
  test "Entry does not exist after it is destroyed" do
    delete "/entry/#{@entry1.id}",
      headers: { Authorization: @admin_token }
    assert_response :ok
    assert Entry.where(id: @entry1.id).size == 0
  end
  test "Employee is unauthorized to destroy entry" do
    delete "/entry/#{@entry1.id}",
      headers: { Authorization: @user1_token }
    assert_response :unauthorized
  end 
end
