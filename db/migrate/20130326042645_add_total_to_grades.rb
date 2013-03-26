class AddTotalToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :total, :integer
  end
end
