class AddSemesterIdToRents < ActiveRecord::Migration
  def change
    add_column :rents , :semester_id , :integer
    add_index :rents, :semester_id
  end
end
