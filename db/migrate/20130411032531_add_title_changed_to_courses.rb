class AddTitleChangedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :title_changed, :boolean
  end
end
