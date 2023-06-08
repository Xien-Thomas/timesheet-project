class User < ApplicationRecord
  has_one :role
  has_one :vendor
  has_secure_password
  
end
