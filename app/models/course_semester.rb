class CourseSemester < ActiveRecord::Base
  belongs_to :course
  belongs_to :semester
  has_many :sections
end
