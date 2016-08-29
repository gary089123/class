class AddApidToRent < ActiveRecord::Migration
  def change
    add_column :rents , :apid , :integer
  end
end
