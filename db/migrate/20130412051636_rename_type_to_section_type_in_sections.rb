class RenameTypeToSectionTypeInSections < ActiveRecord::Migration
  def change
    rename_column :sections, :type, :section_type
  end
end
