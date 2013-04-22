class Section < ActiveRecord::Base
  attr_accessible :capacity, :class_number, :section, :topic, :units
  belongs_to :course_semester
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :day_times
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
end
