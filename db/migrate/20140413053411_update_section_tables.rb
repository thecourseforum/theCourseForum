class UpdateSectionTables < ActiveRecord::Migration
  def change
  	drop_table :locations_sections
  	add_column :sections, :location_id, :integer
  end
end
