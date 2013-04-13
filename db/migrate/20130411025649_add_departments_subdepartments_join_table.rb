class AddDepartmentsSubdepartmentsJoinTable < ActiveRecord::Migration
  def up
    create_table :departments_subdepartments, :id => false do |t|
      t.integer :department_id
      t.integer :subdepartment_id
    end
  end

  def down
    drop_table :departments_subdepartments
  end
end
