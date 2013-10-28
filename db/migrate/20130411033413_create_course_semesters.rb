class CreateCourseSemesters < ActiveRecord::Migration
  def change
    create_table :course_semesters do |t|
      t.references :course
      t.references :semester

      t.timestamps
    end
    add_index :course_semesters, :course_id
    add_index :course_semesters, :semester_id
  end
end
