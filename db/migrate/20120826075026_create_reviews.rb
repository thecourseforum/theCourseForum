class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :section_id
      t.integer :user_id
      t.timestamp :post_date
      t.float :rate_overall
      t.float :rate_professor
      t.float :rate_fun
      t.float :rate_difficulty
      t.float :rate_recommend

      t.timestamps
    end
  end
end
