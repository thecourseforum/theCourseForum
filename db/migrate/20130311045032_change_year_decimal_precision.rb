class ChangeYearDecimalPrecision < ActiveRecord::Migration
  def up
  end
  def change
    change_column :semesters, :year, :decimal, :precision => 4, :scale => 0, :default => 0000
    change_column :students, :grad_year, :decimal, :precision => 4, :scale => 0, :default => 0000
  end
  def down
  end
end
