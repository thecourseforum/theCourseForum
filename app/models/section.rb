class Section < ActiveRecord::Base
  belongs_to :course_semester
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :day_times
end
