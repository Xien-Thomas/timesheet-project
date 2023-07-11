class User < ApplicationRecord
  belongs_to :role
  belongs_to :vendor, optional: true
  has_one :timesheet, dependent: :destroy
  has_secure_password
  
end
