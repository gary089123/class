class AddClassToSrentsTime < ActiveRecord::Migration
  def change
    add_column :srent_times , :class , :string
  end
end
