class AddStoreToBranches < ActiveRecord::Migration[5.0]
  def change
    add_reference :branches, :store, type: :uuid, foreign_key: true
  end
end
