class ChangeGpaDecimalPrecision < ActiveRecord::Migration
  def up
  end

  def change
    change_column :grades, :gpa, :decimal, :precision => 4, :scale => 3, :default => 0.000
  end
  def down
  end
end
