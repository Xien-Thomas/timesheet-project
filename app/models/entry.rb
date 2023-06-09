class Entry < ApplicationRecord
  belongs_to :type
  belongs_to :timesheet
end
