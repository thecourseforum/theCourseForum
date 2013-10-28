class AddReviewStatsToReviews < ActiveRecord::Migration
  def up
    change_table :reviews do |t|
      t.decimal :professor_rating, :precision => 13, :scale => 2, :default => 0.00
      t.integer :enjoyability, :default => 0
      t.integer :difficulty, :default => 0
      t.decimal :amount_reading, :precision => 13, :scale => 2, :default => 0.00
      t.decimal :amount_writing, :precision => 13, :scale => 2, :default => 0.00
      t.decimal :amount_group, :precision => 13, :scale => 2, :default => 0.00
      t.decimal :amount_homework, :precision => 13, :scale => 2, :default => 0.00
      t.boolean :only_tests, :default => false
      t.integer :recommend, :default => 0
      t.string  :ta_name
    end
  end

  def down
    remove_column :reviews, :professor_rating
    remove_column :reviews, :enjoyability
    remove_column :reviews, :difficulty
    remove_column :reviews, :amount_reading
    remove_column :reviews, :amount_writing
    remove_column :reviews, :amount_group
    remove_column :reviews, :amount_homework
    remove_column :reviews, :only_tests
    remove_column :reviews, :recommend
    remove_column :reviews, :ta_name
  end
end
