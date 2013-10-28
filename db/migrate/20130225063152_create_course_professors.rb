class CreateCourseProfessors < ActiveRecord::Migration
  def change
    create_table :course_professors do |t|
      t.references :course
      t.references :professor

      t.timestamps
    end
    add_index :course_professors, :course_id
    add_index :course_professors, :professor_id
  end
end
