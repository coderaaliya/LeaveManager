class AddUserToLeaves < ActiveRecord::Migration[7.1]
  def change
    
    add_reference :leaves, :user, foreign_key: true
  end
end
