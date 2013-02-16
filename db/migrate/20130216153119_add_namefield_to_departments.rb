class AddNamefieldToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :name, :string
  end
end
