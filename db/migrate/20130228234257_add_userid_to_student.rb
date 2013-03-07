class AddUseridToStudent < ActiveRecord::Migration
  def change
    add_index :professors, :user_id
  end
end
