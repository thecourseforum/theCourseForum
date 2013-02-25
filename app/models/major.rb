class Major < ActiveRecord::Base
  attr_accessible :name
  has_many :students, :through => :student_majors
end
