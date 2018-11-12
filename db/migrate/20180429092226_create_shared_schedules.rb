class CreateSharedSchedules < ActiveRecord::Migration
  def change
    create_table :shared_schedules do |t|
      t.string :short_url
      t.string :sections
      t.references :user, index: true, foreign_key: true
      t.integer :clicks

      t.timestamps null: false
    end
  end
end
