class AddNameToBranch < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :name, :string, null: false, default: ''
  end
end
