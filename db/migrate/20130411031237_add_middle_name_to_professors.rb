class AddMiddleNameToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :middle_name, :string
  end
end
