class ChangePrivilegesTypeToArray < ActiveRecord::Migration[5.0]
  def change
    remove_column :admins, :privileges
    add_column :admins, :privileges, :string, array: true, default: []
  end
end
