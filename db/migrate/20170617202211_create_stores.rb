class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :nit, null: false
      t.string :website
      t.string :address
      t.string :status, null: false, default: :pending_documentation

      t.timestamps
    end
  end
end
