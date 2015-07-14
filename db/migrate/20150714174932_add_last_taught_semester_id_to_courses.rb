class AddLastTaughtSemesterIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :last_taught_semester_id, :integer
  end
end
