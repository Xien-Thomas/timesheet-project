class AddRoleToUsersAndTypeToEntries < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :role, foreign_key: true
    remove_reference :entries, :type, foreign_key: true
    drop_table :roles
    drop_table :types
    add_column :users, :role, :integer, default: 0
    add_column :entries, :type, :integer, default: 0
  end
end
