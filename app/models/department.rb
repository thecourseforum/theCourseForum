class Department < ActiveRecord::Base
  belongs_to :school
  attr_accessible :name
end
