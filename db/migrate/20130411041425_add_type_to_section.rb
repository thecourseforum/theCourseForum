class AddTypeToSection < ActiveRecord::Migration
  def change
    add_column :sections, :type, :string
  end
end
