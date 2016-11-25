class ChangeUserIdnumberType < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :users do |t|
	dir.up {t.change :idnumber, :string}
	dir.down {t.change :idnumber, :integer}
      end
    end
  end
end
