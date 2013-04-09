class Subdepartment < ActiveRecord::Base
  belongs_to :department
  attr_accessible :mnemonic, :name

end
