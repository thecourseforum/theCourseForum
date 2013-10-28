class RemoveOldUserFields < ActiveRecord::Migration
  def up
    remove_column :users, :password_digest
    remove_column :users, :last_login
  end

  def down
    add_column :users, :password_digest, :string
    add_column :users, :last_login, :datetime
  end
end
