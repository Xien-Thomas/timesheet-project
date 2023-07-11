class User < ApplicationRecord
  belongs_to :role
  belongs_to :vendor, optional: true
  has_one :timesheet, dependent: :destroy
  has_secure_password

  def is_an_employee?
    return role.name == 'Employee'
  end
  
  def is_a_manager?
    return role.name == 'Manager'
  end

  def is_an_admin?
    return role.name == 'Admin'
  end
  
  def is_not_an_employee?
    return role.name != 'Employee'
  end
  
  def is_not_a_manager?
    return role.name != 'Manager'
  end

  def is_not_an_admin?
    return role.name != 'Admin'
  end
end
