class ChangeDaysToDayInDayTimes < ActiveRecord::Migration
  def change
    rename_column :day_times, :days, :day
  end
end
