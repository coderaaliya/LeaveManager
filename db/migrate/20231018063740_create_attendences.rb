class CreateAttendences < ActiveRecord::Migration[7.1]
  def change
    create_table :attendences do |t|
      t.date :date
      t.boolean :is_holiday
      t.boolean :day_present
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
