class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.date :date
      t.decimal :hours
      t.references :type, null: false, foreign_key: true
      t.references :timesheet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
