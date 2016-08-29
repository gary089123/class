class AddStatusToRents < ActiveRecord::Migration
  def change
    add_column :rents , :status , :string
  end
end
