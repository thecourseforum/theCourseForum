class RemoveNameFromStudentsAndProfessors < ActiveRecord::Migration
  def change
    remove_column :students, :first_name
    remove_column :students, :last_name

    remove_column :professors, :first_name
    remove_column :professors, :last_name
  end
end
