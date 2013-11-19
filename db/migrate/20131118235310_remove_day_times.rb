class RemoveDayTimes < ActiveRecord::Migration
  def change
    drop_table :day_times
  end
end
