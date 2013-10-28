class ChangeSisCourseNumberToSisClassNumberInSection < ActiveRecord::Migration
  def change
    rename_column :sections, :sis_course_number, :sis_class_number
  end
end
