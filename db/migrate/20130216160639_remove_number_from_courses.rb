class RemoveNumberFromCourses < ActiveRecord::Migration
  def up
    remove_column :courses, :course_number
  end

  def down
    add_column :courses, :course_number, :integer
  end
end
