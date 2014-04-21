class AddCourseIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :course_id, :integer
  end
end
