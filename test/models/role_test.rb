require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "can find role using find_by_name" do
    assert Role.find_by_name('eMpLoYee').name == 'Employee'
  end
end
