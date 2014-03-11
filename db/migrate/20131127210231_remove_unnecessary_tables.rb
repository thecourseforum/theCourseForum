class RemoveUnnecessaryTables < ActiveRecord::Migration
  def change
    drop_table :day_times_sections
    drop_table :locations_sections
  end
end
