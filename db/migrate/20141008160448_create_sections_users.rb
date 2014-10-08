class CreateSectionsUsers < ActiveRecord::Migration
  def change
    create_table :sections_users, id: false do |t|
      t.belongs_to :section
      t.belongs_to :user
    end

    add_index "sections_users", ["user_id", "section_id"], name: "index_sections_users_on_user_id_and_section_id", unique: true, using: :btree
  end
end
