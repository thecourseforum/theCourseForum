class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :class_number
      t.integer :section
      t.string :topic
      t.string :units
      t.integer :capacity
      t.references :course_semester

      t.timestamps
    end
    add_index :sections, :course_semester_id
  end
end
