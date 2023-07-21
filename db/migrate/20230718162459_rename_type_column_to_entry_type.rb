class RenameTypeColumnToEntryType < ActiveRecord::Migration[7.0]
  def change
    rename_column :entries, :type, :entry_type
  end
end
