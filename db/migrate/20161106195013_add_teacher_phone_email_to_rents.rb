class AddTeacherPhoneEmailToRents < ActiveRecord::Migration
  def change
    add_column :rents , :teacher , :string
    add_column :rents , :phone , :string
    add_column :rents , :email , :string
  end
end
