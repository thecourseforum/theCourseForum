class ReaddOldTables < ActiveRecord::Migration
  def change
  	create_table :day_times do |t|
      t.string :days
      t.string :start_time
      t.string :end_time     

      t.timestamps
    end

    create_table :locations do |t|
      t.string :location

      t.timestamps
    end

    create_table :day_times_sections, :id => false do |t|
      t.integer :day_time_id
      t.integer :section_id
    end

    create_table :locations_sections, :id => false do |t|
      t.integer :location_id
      t.integer :section_id
    end

  end
end
