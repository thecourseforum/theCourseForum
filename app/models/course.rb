class Course < ActiveRecord::Base
  belongs_to :subdepartment
  attr_accessible :course_number, :title
  has_many :professors, :through => :course_professors
  has_many :course_professors
  has_many :semesters, :through => :course_semesters

end
