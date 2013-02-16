class AddNameToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :name_string, :string
  end
end
