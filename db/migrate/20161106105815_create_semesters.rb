class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :name
      t.integer :updown
      t.string :description
      t.boolean :is_open
      t.datetime :start
      t.datetime :end
      t.timestamps null: false
    end
  end
end
