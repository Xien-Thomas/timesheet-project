require "test_helper"
require_relative '../set_up_test.rb'

class VendorControllerTest < ActionDispatch::IntegrationTest
  extend SetUpTest
  set_up_test

  test "Only Admin can create a tag" do
    post "/vendor/create",
      headers: { Authorization: @admin_token }, 
      params: { name: 'aoi'}, 
      as: :json
    assert_response :created
    assert Vendor.find_by_name('aoi')
  end
  test "Manager can't create tag" do
    post "/vendor/create",
      headers: { Authorization: @manager_token}, 
      params: { name: 'aoi'}, 
      as: :json
    assert_response :unauthorized
    assert Vendor.find_by_name('aoi').nil?
  end

  test "Employee can't create tag" do
    post "/vendor/create",
      headers: { Authorization: @user1_token}, 
      params: { name: 'aoi'}, 
      as: :json
    assert_response :unauthorized
    assert Vendor.find_by_name('aoi').nil?
  end

end

