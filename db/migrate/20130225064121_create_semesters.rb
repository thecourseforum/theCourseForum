class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :number
      t.string :season
      t.decimal :year

      t.timestamps
    end
  end
end
