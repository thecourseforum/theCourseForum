class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :course_id
      t.integer :professor_id
      t.float :rate_overall
      t.float :rate_professor
      t.float :rate_fun
      t.float :rate_difficulty
      t.float :rate_recommend

      t.timestamps
    end
  end
end
