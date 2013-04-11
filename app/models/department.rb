class Department < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :subdepartment
  attr_accessible :name
end
