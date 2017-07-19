class CreateJoinTableBranchContactInformation < ActiveRecord::Migration[5.0]
  def change
    create_join_table(:branches, :contact_informations, column_options: { type: :uuid }) do |t|
      t.index [:branch_id, :contact_information_id], name: :index_branches_contact_informations
    end
  end
end
