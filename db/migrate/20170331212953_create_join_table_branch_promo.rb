class CreateJoinTableBranchPromo < ActiveRecord::Migration[5.0]
  def change
    create_join_table(:branches, :promos, column_options: { type: :uuid }) do |t|
      t.index [:branch_id, :promo_id]
    end
  end
end
