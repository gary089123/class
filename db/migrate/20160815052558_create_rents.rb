class CreateRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.string :name
      t.integer :facility
      t.datetime :start
      t.datetime :end

      t.timestamps null: false
    end
  end
end
