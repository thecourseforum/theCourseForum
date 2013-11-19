class RemoveCourseProfessors < ActiveRecord::Migration
  def change
    drop_table :course_professors
  end
end
