class CreatePromos < ActiveRecord::Migration[5.0]
  def change
    create_table :promos, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.text :terms
      t.integer :stock
      t.decimal :price
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
