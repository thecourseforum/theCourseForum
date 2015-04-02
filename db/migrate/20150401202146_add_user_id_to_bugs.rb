class AddUserIdToBugs < ActiveRecord::Migration
  def change
  	add_column :bugs, :user_id, :integer
  end
end
