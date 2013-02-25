class CourseProfessor < ActiveRecord::Base
  belongs_to :course
  belongs_to :professor
  has_many :grades
  has_many :reviews
  # attr_accessible :title, :body
end
