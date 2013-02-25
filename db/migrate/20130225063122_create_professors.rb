class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :first_name
      t.string :last_name
      t.string :preferred_name
      t.string :email_alias
      t.references :department
      t.references :user

      t.timestamps
    end
    add_index :professors, :department_id
    add_index :professors, :user_id
  end
end
