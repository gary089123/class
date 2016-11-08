class Srent < ActiveRecord::Migration
  def change
    create_table :srents do |t|
      t.string :name
      t.integer :facility
      t.date :startd
      t.date :endd
      t.string :classes
      t.integer :amount
      t.string :status
      t.integer :user_id
      t.string :teacher
      t.string :phone
      t.string :email


      t.timestamps null: false
      end
    end
end
