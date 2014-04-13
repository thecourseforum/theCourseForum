class Section < ActiveRecord::Base
  belongs_to :course_semester
  has_many :section_professors
  has_many :professors, :through => :section_professors
  has_many :grades
  has_many :day_times_sections
  has_many :day_times, :through => :day_times_sections
  belongs_to :location
  belongs_to :semester
  has_many :section_users
  has_many :users, :through => :section_users
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :day_times
end
