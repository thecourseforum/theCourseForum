class AddNameToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :first_name, :string
    add_column :professors, :last_name, :string
  end
end
