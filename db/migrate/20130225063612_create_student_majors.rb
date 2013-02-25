class CreateStudentMajors < ActiveRecord::Migration
  def change
    create_table :student_majors do |t|
      t.references :student
      t.references :major

      t.timestamps
    end
    add_index :student_majors, :student_id
    add_index :student_majors, :major_id
  end
end
