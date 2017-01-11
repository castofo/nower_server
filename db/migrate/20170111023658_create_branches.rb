class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches, id: :uuid do |t|
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.string :address, null: false
      t.boolean :default_contact_info, default: true

      t.timestamps
    end
  end
end
