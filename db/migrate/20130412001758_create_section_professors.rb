class CreateSectionProfessors < ActiveRecord::Migration
  def change
    create_table :section_professors do |t|
      t.references :section
      t.references :professor

      t.timestamps
    end
    add_index :section_professors, :section_id
    add_index :section_professors, :professor_id
  end
end
