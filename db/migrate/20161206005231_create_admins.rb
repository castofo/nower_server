class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :admin_type, null: false
      t.integer :privileges, null: false, default: 0
      t.datetime :activated_at, default: nil

      t.timestamps
    end
  end
end
