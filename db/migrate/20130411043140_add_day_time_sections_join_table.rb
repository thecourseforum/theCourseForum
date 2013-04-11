class AddDayTimeSectionsJoinTable < ActiveRecord::Migration
  def up
    create_table :day_times_sections, :id => false do |t|
      t.integer :day_time_id
      t.integer :section_id
    end
  end

  def down
    drop_table :day_times_sections
  end
end
