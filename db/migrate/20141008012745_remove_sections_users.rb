class RemoveSectionsUsers < ActiveRecord::Migration
  def change
    drop_table :section_users
  end
end
