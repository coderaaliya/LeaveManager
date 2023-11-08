class AddTeamLeadIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :team_lead_id, :integer
  end
end
