class Review < ActiveRecord::Base
  belongs_to :CourseProfessor
  belongs_to :student
  belongs_to :semester
  belongs_to :course_professor
  attr_accessible :comment
end
