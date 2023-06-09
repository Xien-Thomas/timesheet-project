class FixNotNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, 'vendor_id', true
  end
end
