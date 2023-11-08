class AddLeavesToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :Total_leaves_allowed, :integer
  end
end
