class AddLocationsSectionsJoinTable < ActiveRecord::Migration
  def up
    create_table :locations_sections, :id => false do |t|
      t.integer :location_id
      t.integer :section_id
    end
  end

  def down
    drop_table :locations_sections
  end
end
