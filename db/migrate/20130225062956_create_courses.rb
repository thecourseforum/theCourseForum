class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.decimal :course_number
      t.references :subdepartment

      t.timestamps
    end
    add_index :courses, :subdepartment_id
  end
end
