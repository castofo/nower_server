class AddUniqueIndexToAdminsEmail < ActiveRecord::Migration[5.0]
  def change
    add_index :admins, :email, unique: true
  end
end
