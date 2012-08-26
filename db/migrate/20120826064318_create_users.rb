class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :graduation
      t.string :major1
      t.string :major2
      t.string :major3

      t.timestamps
    end
  end
end
