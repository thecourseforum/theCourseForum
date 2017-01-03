class AddDeletedToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :deleted, :boolean, :null => false, :default => false
  end
end
