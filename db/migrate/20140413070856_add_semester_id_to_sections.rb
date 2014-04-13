class AddSemesterIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :semester_id, :integer
  end
end
