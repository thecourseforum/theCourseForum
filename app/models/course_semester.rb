class CourseSemester < ActiveRecord::Base
  belongs_to :course
  belongs_to :semester
  # attr_accessible :title, :body
end
