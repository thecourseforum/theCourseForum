class UpdateSections < ActiveRecord::Migration
  def change
    remove_column :sections, :location_id
    add_column :day_times_sections, :location_id, :integer
  end
end
