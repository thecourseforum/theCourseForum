class Semester < ActiveRecord::Base
  attr_accessible :number, :season, :year
  has_many :courses, :through => :course_semesters
end
