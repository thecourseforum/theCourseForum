class ChangeGradesCourseProfessorIdFieldName < ActiveRecord::Migration
  def change
    rename_column :grades, :CourseProfessor_id, :course_professor_id
  end
end
