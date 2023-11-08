class AddLeavesCountToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :leaves_taken, :integer
  end
end
