class CreateProfessorUsers < ActiveRecord::Migration
  def change
    create_table :professor_users do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
