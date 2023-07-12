require "test_helper"

class VendorTest < ActiveSupport::TestCase
  test "can find vendor using find_by_name" do
    assert Vendor.find_by_name('Revature').name == 'revature'
  end
end
