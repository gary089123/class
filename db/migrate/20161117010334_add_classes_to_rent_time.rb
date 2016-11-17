class AddClassesToRentTime < ActiveRecord::Migration
  def change
    add_column :rent_times , :classes , :string
  end
end
