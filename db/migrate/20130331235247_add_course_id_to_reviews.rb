class AddCourseIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :course_id, :integer
  end
end
