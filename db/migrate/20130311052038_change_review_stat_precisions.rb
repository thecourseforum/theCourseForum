class ChangeReviewStatPrecisions < ActiveRecord::Migration
  def change
    change_column :reviews, :professor_rating, :decimal, :precision => 11, :scale => 2, :default => 0.00
    change_column :reviews, :amount_reading, :decimal, :precision => 11, :scale => 2, :default => 0.00
    change_column :reviews, :amount_writing, :decimal, :precision => 11, :scale => 2, :default => 0.00
    change_column :reviews, :amount_group, :decimal, :precision => 11, :scale => 2, :default => 0.00
    change_column :reviews, :amount_homework, :decimal, :precision => 11, :scale => 2, :default => 0.00
  end
end
