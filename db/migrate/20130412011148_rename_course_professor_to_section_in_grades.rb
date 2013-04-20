class RenameCourseProfessorToSectionInGrades < ActiveRecord::Migration
  def change
    rename_column :grades, :course_professor_id, :section_id
  end
end
