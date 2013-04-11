class RemoveDepartmentIdFromSubdepartments < ActiveRecord::Migration
  def change
    remove_column :subdepartments, :department_id
  end
end
