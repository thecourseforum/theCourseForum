class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :comment
      t.references :CourseProfessor
      t.references :student
      t.references :semester

      t.timestamps
    end
    add_index :reviews, :CourseProfessor_id
    add_index :reviews, :student_id
    add_index :reviews, :semester_id
  end
end
