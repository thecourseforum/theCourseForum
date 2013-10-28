class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.references :CourseProfessor
      t.references :semester
      t.decimal :gpa
      t.integer :count_a
      t.integer :count_aminus
      t.integer :count_bplus
      t.integer :count_b
      t.integer :count_bminus
      t.integer :count_cplus
      t.integer :count_c
      t.integer :count_cminus
      t.integer :count_dplus
      t.integer :count_d
      t.integer :count_dminus
      t.integer :count_f
      t.integer :count_drop
      t.integer :count_withdraw
      t.integer :count_other

      t.timestamps
    end
    add_index :grades, :CourseProfessor_id
    add_index :grades, :semester_id
  end
end
