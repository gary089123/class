class CreateRentTimes < ActiveRecord::Migration
  def change
    create_table :rent_times do |t|
      t.integer :rent_id
      t.datetime :start
      t.datetime :end
      t.timestamps null: false
    end

    add_index :rent_times, :rent_id
  end
end
