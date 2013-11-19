class Section < ActiveRecord::Base
  belongs_to :course_semester
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
end
