class Role < ApplicationRecord
  has_many :users
  
  def self.find_by_name(name)
    Role.where(name: name.capitalize).first
  end
end
