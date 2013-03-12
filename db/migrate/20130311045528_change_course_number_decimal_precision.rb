class ChangeCourseNumberDecimalPrecision < ActiveRecord::Migration
  def up
  end
  def change
    change_column :courses, :course_number, :decimal, :precision => 4, :scale => 0, :default => 0000
  end
  def down
  end
end
