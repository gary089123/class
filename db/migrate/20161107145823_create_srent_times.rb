class CreateSrentTimes < ActiveRecord::Migration
  def change
    create_table :srent_times do |t|
      t.integer :srent_id
      t.datetime :start
      t.datetime :end
      t.timestamps null: false
    end
    add_index :srent_times, :srent_id
  end
end
