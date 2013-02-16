class RemoveNameFromDepartments < ActiveRecord::Migration
  def up
    remove_column :departments, :name_string
  end

  def down
    add_column :departments, :name_string, :string
  end
end
