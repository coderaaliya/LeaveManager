class CreateLeaves < ActiveRecord::Migration[7.1]
  def change
    create_table :leaves do |t|
      t.integer :status
      t.text :reason
      t.date :from_date
      t.date :to_date
      t.integer :leave_type

      t.timestamps
    end
  end
end
