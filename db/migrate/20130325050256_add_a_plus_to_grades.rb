class AddAPlusToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :count_aplus, :integer
  end
end
