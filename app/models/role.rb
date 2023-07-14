class Role < ApplicationRecord
  has_many :users
  
  def self.find_by_name(name)
    return unless name.is_a? String
    Role.where(name: name.capitalize).first
  end
end
