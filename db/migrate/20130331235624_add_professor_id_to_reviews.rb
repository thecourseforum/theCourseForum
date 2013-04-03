class AddProfessorIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :professor_id, :integer
  end
end
