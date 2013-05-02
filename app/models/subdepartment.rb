class Subdepartment < ActiveRecord::Base
  has_and_belongs_to_many :department
  attr_accessible :mnemonic, :name
  has_many :courses
end
