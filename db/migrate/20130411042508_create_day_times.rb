class CreateDayTimes < ActiveRecord::Migration
  def change
    create_table :day_times do |t|
      t.string :day_time

      t.timestamps
    end
  end
end
