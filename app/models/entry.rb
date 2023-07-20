class Entry < ApplicationRecord
  belongs_to :timesheet
  enum entry_type: [:standard, :pto, :holiday]
  enum status: [:pending, :approved, :rejected]
  validate :prevent_change_after_approval, on: :update

  private

  def prevent_change_after_approval
    if !self.timesheet.user.admin? && !self.pending? && (self.date_changed? || self.hours_changed? || self.entry_type_changed?)
      errors.add :cannot, "be updated after approval or rejection!" 
    end
  end

end
