class RemoveProfessorUsers < ActiveRecord::Migration
  def change
    drop_table :professor_users
  end
end
