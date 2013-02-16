class RemoveLongNameFromDepartments < ActiveRecord::Migration
  def up
    remove_column :departments, :long_name
  end

  def down
    add_column :departments, :long_name, :string
  end
end
