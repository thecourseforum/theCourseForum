class CreateSectionUsers < ActiveRecord::Migration
  def change
    create_table :section_users do |t|
      t.integer :section_id
      t.integer :user_id

      t.timestamps
    end
  end
end
