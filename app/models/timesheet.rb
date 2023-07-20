class Timesheet < ApplicationRecord
  belongs_to :user
  has_many :entries, dependent: :destroy

  accepts_nested_attributes_for :entries
  accepts_nested_attributes_for :user
end
