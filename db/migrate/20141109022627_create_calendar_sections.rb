class CreateCalendarSections < ActiveRecord::Migration
  def change
    create_table :calendar_sections do |t|
      t.integer :section_id
      t.integer :user_id
    end
  end
end
