class AddApidToSrent < ActiveRecord::Migration
  def change
    add_column :srents , :apid , :integer 
  end
end
