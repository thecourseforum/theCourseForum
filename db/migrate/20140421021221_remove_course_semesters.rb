class RemoveCourseSemesters < ActiveRecord::Migration
  def change
    drop_table :course_semesters
    remove_index :sections, :course_semester_id
    remove_column :sections, :course_semester_id, :integer
  end
end
