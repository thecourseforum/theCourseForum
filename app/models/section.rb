class Section < ActiveRecord::Base
  belongs_to :course_semester
  has_many_and_belongs_to :locations
  has_many_and_belongs_to :day_times
  has_many :professors, :through => :section_professors
  attr_accessible :capacity, :class_number, :section, :topic, :units
end
