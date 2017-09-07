class CreateOpeningTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :opening_times do |t|
      t.integer :open_day, null: false
      t.integer :open_time, null: false
      t.integer :close_day, null: false
      t.integer :close_time, null: false
      t.references :branch, type: :uuid, foreign_key: true, null: false
    end
  end
end
