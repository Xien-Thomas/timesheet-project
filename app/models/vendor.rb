class Vendor < ApplicationRecord
  has_many :users

  def self.find_by_name(name)
    Vendor.where(name: name.downcase).first
  end
end
