class CreateSubdepartments < ActiveRecord::Migration
  def change
    create_table :subdepartments do |t|
      t.string :name
      t.string :mnemonic
      t.references :department

      t.timestamps
    end
    add_index :subdepartments, :department_id
  end
end
