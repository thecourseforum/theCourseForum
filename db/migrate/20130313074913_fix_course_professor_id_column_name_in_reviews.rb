class FixCourseProfessorIdColumnNameInReviews < ActiveRecord::Migration
  def up
    rename_column :reviews, :CourseProfessor_id, :course_professor_id
  end

  def down
    rename_column :reviews, :course_professor_id, :CourseProfessor_id 
  end
end
