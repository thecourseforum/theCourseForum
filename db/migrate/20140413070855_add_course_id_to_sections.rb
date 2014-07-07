class AddCourseIdToSections < ActiveRecord::Migration
  def up
    add_column :sections, :course_id, :integer
  end

  def down
    remove_column :sections, :course_id
  end
end
