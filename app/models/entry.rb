class Entry < ApplicationRecord
  has_one :type
  belongs_to :timesheet
end
