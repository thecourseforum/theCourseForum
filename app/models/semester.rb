class Semester < ActiveRecord::Base
  has_many :courses, :through => :course_semesters
end
