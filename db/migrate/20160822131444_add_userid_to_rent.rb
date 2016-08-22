class AddUseridToRent < ActiveRecord::Migration
  def change
    add_column :rents ,:user_id, :integer
    add_index :rents ,:user_id
  end
end
