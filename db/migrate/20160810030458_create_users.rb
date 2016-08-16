class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :idnumber
      t.string :name
      t.string :unit

      t.timestamps null: false
    end
  end
end
