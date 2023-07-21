class Vendor < ApplicationRecord
  has_many :users
  validates :name, presence: true, uniqueness: true
  def self.find_by_name(name)
    return unless name.is_a? String
    Vendor.where(name: name.downcase).first
  end
end
