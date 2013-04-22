class ChangeClassNumberToSisCourseNumberInSection < ActiveRecord::Migration
  def change
    rename_column :sections, :class_number, :sis_course_number
  end
end
