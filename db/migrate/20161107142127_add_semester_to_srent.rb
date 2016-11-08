class AddSemesterToSrent < ActiveRecord::Migration
  def change
    add_column :srents , :semester_id , :integer
    add_index :srents, :semester_id
  end
end
