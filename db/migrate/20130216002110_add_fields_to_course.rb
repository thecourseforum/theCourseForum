class AddFieldsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :course_number, :integer
  end
end
