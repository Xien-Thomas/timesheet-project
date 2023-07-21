class User < ApplicationRecord
  belongs_to :vendor, optional: true
  has_one :timesheet, dependent: :destroy
  enum role: [:employee, :manager, :admin]
  has_secure_password
end
