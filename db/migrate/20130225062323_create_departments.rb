class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.references :school

      t.timestamps
    end
    add_index :departments, :school_id
  end
end
