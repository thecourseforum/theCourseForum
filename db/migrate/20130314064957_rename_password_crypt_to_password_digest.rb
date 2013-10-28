class RenamePasswordCryptToPasswordDigest < ActiveRecord::Migration
  def change
    rename_column :users, :password_crypt, :password_digest
  end
end
