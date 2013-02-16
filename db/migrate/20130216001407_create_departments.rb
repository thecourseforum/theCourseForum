class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :long_name
      t.string :prefix

      t.timestamps
    end
  end
end
