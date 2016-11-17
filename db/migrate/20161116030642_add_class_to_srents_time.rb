class AddClassToSrentsTime < ActiveRecord::Migration
  def change
    add_column :srent_times , :classes , :string
  end
end
