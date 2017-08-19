class CreateContactInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_informations, id: :uuid do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.references :store, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end
  end
end
