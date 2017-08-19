class AddUniqueIndexToContactInformationsKeyAndStoreId < ActiveRecord::Migration[5.0]
  def change
    add_index :contact_informations, [:store_id, :key], unique: true
  end
end
