class ChangeSectionColumnToSectionNumberInSection < ActiveRecord::Migration
  def change
    rename_column :sections, :section, :section_number
  end
end
