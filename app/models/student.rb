class Student < ActiveRecord::Base
  attr_accessible :first_name, :grad_year, :last_name
  has_many :majors, :through => :student_majors
  has_many :reviews
end
