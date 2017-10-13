class RefactorOpeningTimesNamesAndTypes < ActiveRecord::Migration[5.0]
  def change
    # Remove close_day column, we don't need that
    remove_column :opening_times, :close_day, :integer

    # Rename open_day to day
    rename_column :opening_times, :open_day, :day

    # Recreate open_time column to opens_at, using time as type
    remove_column :opening_times, :open_time, :integer
    add_column :opening_times, :opens_at, :time, null: false

    # Recreate close_time column to closes_at, using time as type
    remove_column :opening_times, :close_time, :integer
    add_column :opening_times, :closes_at, :time, null: false

    # Add valid_from and valid_through columns
    add_column :opening_times, :valid_from, :date, null: false
    add_column :opening_times, :valid_through, :date
  end
end
