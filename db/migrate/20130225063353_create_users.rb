class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_crypt
      t.string :old_password
      t.references :student
      t.references :professor
      t.datetime :last_login
      t.boolean :subscribed_to_email

      t.timestamps
    end
    add_index :users, :student_id
    add_index :users, :professor_id
  end
end
